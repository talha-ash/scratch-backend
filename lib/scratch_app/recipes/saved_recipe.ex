defmodule ScratchApp.Recipes.SavedRecipe do
  use Ecto.Schema

  import Ecto.Changeset
  alias ScratchApp.Recipes.Recipe

  schema "saved_recipes" do
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :recipe, Recipe, foreign_key: :recipe_id
    belongs_to :category, Category, foreign_key: :category_id
    timestamps()
  end

  @required ~w(user_id recipe_id  category_id)a

  @doc false
  def changeset(%__MODULE__{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:recipe_id)
    |> foreign_key_constraint(:category_id)
    |> unique_constraint([:user_id, :recipe_id, :category_id])
  end
end
