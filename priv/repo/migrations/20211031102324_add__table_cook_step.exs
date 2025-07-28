defmodule ScratchApp.Repo.Migrations.AddTableCookStep do
  use Ecto.Migration

  def change do
    create table(:cooking_steps) do
      add(:step, :integer)
      add(:description, :string)
      add(:video, :string)
      add(:video_title, :string)
      add(:recipe_id, references("recipes"))
      timestamps()
    end

    create(index(:cooking_steps, [:recipe_id]))
  end
end
