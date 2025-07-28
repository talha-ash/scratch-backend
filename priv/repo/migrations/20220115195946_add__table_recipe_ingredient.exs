defmodule ScratchApp.Repo.Migrations.AddTableRecipeIngredient do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add(:description, :string)
      add(:image, :string)
      add(:recipe_id, references("recipes"))
      timestamps()
    end

    # create(unique_index(:ingredients, [:recipe_id]))
  end
end
