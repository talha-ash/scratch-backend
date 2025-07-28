defmodule ScratchApp.Repo.Migrations.AlterTableRecipeAddColumn do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add(:cover_image_id, references("recipe_images"))
      add(:category_id, references("categories"))
    end
  end
end
