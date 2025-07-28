defmodule ScratchApp.Repo.Migrations.AddTableRecipeLikes do
  use Ecto.Migration

  def change do
    create table(:recipe_likes) do
      add(:recipe_id, references("recipes"))
      add(:user_id, references("users"))
      timestamps()
    end

    create(unique_index(:recipe_likes, [:recipe_id, :user_id]))
  end
end
