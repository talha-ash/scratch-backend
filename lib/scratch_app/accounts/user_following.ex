defmodule ScratchApp.Accounts.UserFollowing do
  use Ecto.Schema

  import Ecto.Changeset

  schema "followings" do
    belongs_to(:follower, Currencies, foreign_key: :follower_id)
    belongs_to(:following, Currencies, foreign_key: :following_id)
    timestamps()
  end

  @required ~w(follower_id following_id)a

  @doc false
  def changeset(%__MODULE__{} = user_following, attrs \\ %{}) do
    user_following
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:follower_id)
    |> foreign_key_constraint(:following_id)
    |> unique_constraint([:follower_id, :following_id])
  end
end
