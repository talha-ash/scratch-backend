defmodule ScratchApp.Recipes.RecipeCategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias ScratchApp.Accounts.User
  alias ScratchApp.Recipes.Recipe

  schema "recipe_categories" do
    field :name, :string
    field :image_url, :string

    belongs_to :user, User
    # we will not use on_replace here because we want to keep the recipes or unreach case
    has_many :recipes, Recipe, on_delete: :nilify_all
    timestamps(type: :utc_datetime)
  end

  def changeset(recipe_category, attrs) do
    recipe_category
    |> cast(attrs, [:name, :image_url, :user_id])
    |> validate_required([:name, :user_id, :image_url])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:name)
  end
end
