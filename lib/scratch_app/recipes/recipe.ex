defmodule ScratchApp.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias ScratchApp.Accounts.User
  alias ScratchApp.Recipes.{CookingStep, RecipeImage, Ingredient, Category}

  schema "recipes" do
    field :name, :string
    field :serve_time, :integer
    field :nutrition_facts, {:array, :string}

    belongs_to :category, Category, foreign_key: :category_id
    belongs_to :user, User, foreign_key: :user_id
    # belongs_to :cookbook_categorie, User, foreign_key: :user_id
    has_many(:cooking_steps, CookingStep, on_replace: :delete)
    has_many(:recipe_images, RecipeImage, on_replace: :delete)
    has_many(:ingredients, Ingredient, on_replace: :delete)
    timestamps()
  end

  @required ~w(name serve_time nutrition_facts user_id category_id)a

  @doc false
  def changeset(%__MODULE__{} = recipe, attrs) do
    recipe
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:category_id)
  end

  def associated_changeset(%__MODULE__{} = recipe, attrs) do
    recipe
    |> cast(attrs, @required)
    |> Ingredient.cast_assoc_with_recipe(recipe.id)
    |> CookingStep.cast_assoc_with_recipe(recipe.id)
    |> RecipeImage.cast_assoc_with_recipe(recipe.id)
  end
end
