defmodule ScratchApp.Repo.Migrations.AddFieldResfreshTokenToUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:refresh_token, :text, default: "")
    end
  end
end
