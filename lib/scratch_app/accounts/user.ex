defmodule ScratchApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Argon2, only: [hash_pwd_salt: 1]

  schema "users" do
    field :age, :integer
    field :email, :string
    field :password, :string
    field :fullname, :string
    field :username, :string
    field :role, :string
    field :password_one, :string, virtual: true
    field :password_two, :string, virtual: true
    field :refresh_token, :string, load_in_query: true
    timestamps()
  end

  @required ~w(username  email password fullname)a
  @optional ~w(age)a
  @allowed @required ++ @optional

  @registration_required ~w(username email password_one password_two)a
  @registration_optional ~w(age)a
  @registration_allowed @registration_required ++ @registration_optional

  @refresh_token_required ~w(refresh_token)a

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @allowed)
    |> validate_required(@required)
    |> unique_constraint(:email)
  end

  @doc false
  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @registration_allowed)
    |> validate_required(@registration_required)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password_one, min: 3)
    |> validate_length(:password_two, min: 3)
    |> compare_password
    |> put_password_hash
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc false
  def refresh_token_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @refresh_token_required)
    |> validate_required(@refresh_token_required)
    |> validate_length(:refresh_token, min: 300)
    |> validate_length(:refresh_token, max: 360)
  end

  def remove_refresh_token_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @refresh_token_required)
    |> validate_length(:refresh_token, min: 0)
    |> validate_length(:refresh_token, max: 0)
  end

  defp compare_password(changeset) do
    cond do
      get_change(changeset, :password_one) == get_change(changeset, :password_two) ->
        changeset

      true ->
        add_error(changeset, :password_match, "password not match")
    end
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{password_one: password_one}
      } ->
        changeset
        |> put_change(:password, hash_pwd_salt(password_one))

      _ ->
        changeset
    end
  end
end
