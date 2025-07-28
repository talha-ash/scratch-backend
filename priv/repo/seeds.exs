# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ScratchApp.Repo.insert!(%Scratch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ScratchApp.Accounts
alias ScratchApp.Recipes

defmodule SeedData do
  def add_initial_data() do
    {:ok, %Accounts.User{} = admin_user} =
      Accounts.create_user(%{
        fullname: "admin",
        email: "admin@admin.com",
        age: 20,
        password_one: "admin@123",
        password_two: "admin@123",
        roles: ["admin"],
        username: "admin"
      })

    Recipes.create_category(%{title: "Desserts", user_id: admin_user.id})
    Recipes.create_category(%{title: "Chinese", user_id: admin_user.id})
    Recipes.create_category(%{title: "Thai", user_id: admin_user.id})
  end
end

SeedData.add_initial_data()
