defmodule ScratchApp.Repo.Migrations.AddTableCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:title, :string)
      add(:user_id, references("users"))
      timestamps()
    end

    create(unique_index(:categories, [:title, :user_id]))
  end
end
