defmodule ScratchApp.Repo.Migrations.AddTableRecipe do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add(:name, :string)
      add(:serve_time, :integer)
      add(:nutrition_facts, {:array, :string})
      # add(:cover_image_id, references("recipe_images"))
      add(:user_id, references("users"))
      timestamps()
    end
  end
end
