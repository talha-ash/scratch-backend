defmodule ScratchApp.DatabaseSeed do
  alias ScratchApp.Accounts
  alias ScratchApp.Recipes

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
