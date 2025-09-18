defmodule ScratchAppWeb.AuthorizationMiddleware do
  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: current_user}} = resolution, _config) do
    action = resolution.definition.name |> Macro.underscore()
    is_admin_right = required_admin_rights(action)

    case has_rights_access(current_user, is_admin_right) do
      false ->
        resolution
        |> unauthorized

      true ->
        resolution
    end
  end

  def call(resolution, _config) do
    action = resolution.definition.name |> Macro.underscore()

    case match_non_user_action(action) do
      true ->
        resolution

      false ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthenticated"})
    end
  end

  defp unauthorized(resolution) do
    resolution
    |> Absinthe.Resolution.put_result({:error, "unauthorized"})
  end

  defp has_rights_access(current_user, is_admin_right) do
    role = current_user.role

    case is_admin_right do
      true ->
        role == "admin"

      false ->
        role == "client"
    end
  end

  defp match_non_user_action(action) do
    actions = [
      "login",
      "register",
      "refresh_token"
    ]

    Enum.any?(actions, fn a -> a == action end)
  end

  defp required_admin_rights(action) do
    actions = [
      "users"
    ]

    Enum.any?(actions, fn a -> a == action end)
  end
end
