# lib/graphql_tutorial_web/plugs/context.ex
defmodule ScratchAppWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        put_private(conn, :absinthe, %{context: %{remote_ip: conn.remote_ip}})
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- authorize(token) do
      {:ok, %{current_user: user, remote_ip: conn.remote_ip}}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case ScratchApp.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        return_user(claims)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp return_user(claims) do
    case ScratchApp.Guardian.resource_from_claims(claims) do
      {:ok, resource} -> {:ok, resource}
      {:error, reason} -> {:error, reason}
    end
  end
end
