defmodule ScratchApp.Repo.Migrations.AddTableUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:age, :integer)
      add(:fullname, :string)
      add(:email, :string)
      add(:password, :string)
      add :role, :string
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:username]))
  end
end
