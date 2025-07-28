defmodule ScratchApp.Repo.Migrations.AddTableComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:comment, :string)
      add(:recipe_id, references("recipes"))
      add(:user_id, references("users"))
      add(:parent_comment_id, references("comments"))
      timestamps()
    end
  end
end
