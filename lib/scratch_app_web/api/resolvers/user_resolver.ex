defmodule ScratchAppWeb.Resolvers.Users do
  alias ScratchApp.Accounts

  def list_users(_args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def get_user(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def follow_user(args, %{context: %{current_user: current_user}}) do
    args = Map.put(args, :follower_id, current_user.id)

    with {:ok, _user_following} <-
           Accounts.follow_user(args) do
      {:ok, %{message: "Follow Successfully"}}
    else
      {:error, changeset} when is_map(changeset) ->
        {:error, changeset}

      {:error, message} ->
        {:error, message}
    end
  end
end
