defmodule ScratchApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ScratchApp.Repo

  alias ScratchApp.Accounts.{User, UserFollowing}
  import Argon2, only: [verify_pass: 2, no_user_verify: 0]

  @refresh_token_type "refresh"

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %{
      "username" => username,
      "email" => email,
      "password" => password_one,
      "passwordConfirm" => password_two
    } = attrs

    %User{}
    |> User.registration_changeset(%{
      username: username,
      email: email,
      password_one: password_one,
      password_two: password_two
    })
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_auth(%{email: email, password: password}) do
    with {:ok, user} <- get_user(%{email: email}),
         {:ok, user} <- match_password(user, password) do
      {:ok, user}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def user_auth(%{username: username, password: password}) do
    with {:ok, user} <- get_user(%{username: username}),
         {:ok, user} <- match_password(user, password) do
      {:ok, user}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def follow_user(attrs) do
    with true <- not_same_follower(attrs) do
      %UserFollowing{}
      |> UserFollowing.changeset(attrs)
      |> Repo.insert()
    else
      _ ->
        {:error, "Already Followed You"}
    end
  end

  def verify_refresh_token(refresh_token) do
    with {:ok, claims} <-
           ScratchApp.Guardian.decode_and_verify(refresh_token, %{"typ" => @refresh_token_type}),
         {:ok, user} <- ScratchApp.Guardian.resource_from_claims(claims),
         true <- is_user_refresh_token(user, refresh_token) do
      {:ok, user}
    else
      {:error, %{user_id: user_id}} ->
        {:error, %{user_id: user_id}}

      {:error, message} ->
        {:error, message}
    end
  end

  def set_refresh_token(%{user_id: id, refresh_token: refresh_token}) do
    with {:ok, %User{} = user} <- get_user_by_id(id) do
      user
      |> User.refresh_token_changeset(%{refresh_token: refresh_token})
      |> Repo.update()
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def set_refresh_token(%{user: user, refresh_token: refresh_token}) do
    user
    |> User.refresh_token_changeset(%{refresh_token: refresh_token})
    |> Repo.update()
  end

  def remove_refresh_token(user_id) do
    with {:ok, %User{} = user} <- get_user_by_id(user_id) do
      user
      |> User.remove_refresh_token_changeset(%{refresh_token: ""})
      |> Repo.update()
    else
      {:error, message} ->
        {:error, message}
    end
  end

  defp is_user_refresh_token(user, refresh_token) do
    with true <- user.refresh_token == refresh_token do
      true
    else
      false ->
        {:error, %{user_id: user.id}}
    end
  end

  defp not_same_follower(%{follower_id: follower_id, following_id: following_id}) do
    with nil <- Repo.get_by(UserFollowing, follower_id: following_id, following_id: follower_id),
         false <- follower_id == following_id do
      true
    else
      _ ->
        false
    end
  end

  defp get_user(%{email: email}) do
    with %User{} = user <- Repo.get_by(User, email: email) do
      {:ok, user}
    else
      _nil ->
        on_user_not_found()
    end
  end

  defp get_user(%{username: username}) do
    with %User{} = user <- Repo.get_by(User, username: username) do
      {:ok, user}
    else
      _nil ->
        on_user_not_found()
    end
  end

  defp get_user_by_id(id) do
    with %User{} = user <- Repo.get(User, id) do
      {:ok, user}
    else
      _nil ->
        on_user_not_found()
    end
  end

  defp on_user_not_found() do
    no_user_verify()
    message = "User Not Found"
    {:error, message}
  end

  defp match_password(%User{} = user, password) do
    if verify_pass(password, user.password) do
      {:ok, user}
    else
      message = "invalid password"
      {:error, message}
    end
  end
end
