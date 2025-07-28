defmodule ScratchApp.Recipes.Like do
  use Ecto.Schema

  import Ecto.Changeset
  alias ScratchApp.Recipes.Recipe

  schema "recipe_likes" do
    belongs_to :user, User, foreign_key: :user_id, on_replace: :delete
    belongs_to :recipes, Recipe, foreign_key: :recipe_id, on_replace: :delete
    timestamps()
  end

  @required ~w(user_id recipe_id)a

  @doc false
  def changeset(%__MODULE__{} = recipe_like, attrs \\ %{}) do
    recipe_like
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user_id, :recipe_id],
      name: :recipe_likes_recipe_id_user_id_index,
      message: "User already like this recipe"
    )
  end
end
