defmodule ScratchApp.Repo.Migrations.AddTableSavedRecipe do
  use Ecto.Migration

  def change do
    create table(:saved_recipes) do
      add(:user_id, references("users"))
      add(:recipe_id, references("recipes"))
      add(:category_id, references("categories"))
      timestamps()
    end

    create(unique_index(:saved_recipes, [:recipe_id, :category_id, :user_id]))
  end
end
