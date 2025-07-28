defmodule ScratchApp.Repo.Migrations.AddTableRecipeTag do
  use Ecto.Migration

  def change do
    create table(:recipe_tags) do
      add(:recipe_id, references("recipes"))
      add(:tag_id, references("tags"))
      timestamps()
    end

    create(unique_index(:recipe_tags, [:recipe_id, :tag_id]))
  end
end
