defmodule ScratchApp.Repo.Migrations.AddTableRecipeImages do
  use Ecto.Migration

  def change do
    create table(:recipe_images) do
      add(:image, :string)
      add(:recipe_id, references("recipes"))
      timestamps()
    end

    create(index(:recipe_images, [:recipe_id]))
  end
end
