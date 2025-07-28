defmodule ScratchApp.Repo.Migrations.AddTableFollowing do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add(:follower_id, references("users"))
      add(:following_id, references("users"))
      timestamps()
    end

    create(unique_index(:followings, [:follower_id, :following_id]))
  end
end
