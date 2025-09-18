defmodule ScratchAppWeb.GqlUpload do
  @moduledoc """
  Absinthe plug to support Apollo upload format.
  Implementation of https://github.com/jaydenseric/graphql-multipart-request-spec which
  is what urlql uses.
  based on: https://github.com/shavit/absinthe-upload
  """
  @behaviour Plug

  import Plug.Conn, only: [get_req_header: 2]

  @impl true
  def init(conn), do: conn

  # body_params must be already fetched and parsed
  # NOTE: this doesn't support batch operations
  @impl true
  def call(%{body_params: body_params} = conn, _)
      when is_map_key(body_params, "operations") and is_map_key(body_params, "map") do
    # 'operations' contains the JSON payload
    # 'map' contains the JSON mapping between body params keys and variables
    with ["multipart/form-data" <> _] <- get_req_header(conn, "content-type"),
         {:ok, file_mapper} = Jason.decode(body_params["map"]),
         {:ok, %{"query" => query, "variables" => variables}} <-
           Jason.decode(body_params["operations"]) do
      uploads = get_uploads(body_params, file_mapper)
      mapped_variables = add_uploads_to_variables(uploads, variables)

      Map.update!(conn, :params, fn params ->
        params
        |> Map.drop(["operations", "map" | Map.keys(file_mapper)])
        |> Map.merge(%{"query" => query, "variables" => mapped_variables})
        |> Map.merge(uploads)
      end)
    else
      # if request is not a multipart or body doesn't have an operation along
      # side a map of vars mapping to uploads continue (see `graphql-multipart-request-spec`)
      _ -> conn
    end
  end

  def call(conn, _), do: conn

  defp get_uploads(body_params, file_mapper) do
    Map.new(file_mapper, fn {file_key, [path]} ->
      key = path |> String.split(".") |> List.last()
      value = body_params[file_key]
      {key, value}
    end)
  end

  defp add_uploads_to_variables(uploads, variables) do
    Map.new(uploads, fn {key, _} ->
      {key, key}
    end)
    |> Enum.into(variables)
  end
end
