# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ScratchApp.Repo.insert!(%ScratchApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ScratchApp.Repo
alias ScratchApp.Accounts.User
alias ScratchApp.Recipes.{RecipeCategory, Ingredient, Tag}

admin_user = %User{
  email: "admin@admin.com",
  username: "admin",
  fullname: "Admin",
  role: "admin",
  password: Argon2.hash_pwd_salt("admin")
}

users = [
  %User{
    email: "nick@gmail.com",
    username: "nick",
    fullname: "Nick Evan",
    role: "client",
    password: Argon2.hash_pwd_salt("password12345")
  },
  %User{
    email: "john@gmail.com",
    username: "john",
    fullname: "John Doe",
    role: "client",
    password: Argon2.hash_pwd_salt("password12345")
  },
  %User{
    email: "johnny@gmail.com",
    username: "johnny",
    fullname: "Johnny Doe",
    role: "client",
    password: Argon2.hash_pwd_salt("password12345")
  },
  %User{
    email: "bill@gmail.com",
    username: "bill",
    fullname: "Bill Smith",
    role: "client",
    password: Argon2.hash_pwd_salt("password12345")
  }
]

{:ok, admin_user} = Repo.insert(admin_user)
Enum.each(users, fn user -> Repo.insert(user) end)

categories = [
  %RecipeCategory{
    name: "Breakfast",
    image_url: "/uploads/chocolates-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Lunch",
    image_url: "/uploads/west-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Dinner",
    image_url: "/uploads/chocolates-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Snacks",
    image_url: "/uploads/west-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Dessert",
    image_url: "/uploads/chocolates-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Side Dish",
    image_url: "/uploads/west-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Beverage",
    image_url: "/uploads/chocolates-category.png",
    user_id: admin_user.id
  },
  %RecipeCategory{
    name: "Vegetarian",
    image_url: "/uploads/west-category.png",
    user_id: admin_user.id
  }
]

Enum.map(categories, fn category ->
  Repo.insert!(category)
end)

ingrediants = [
  %Ingredient{
    name: "Chicken",
    description: "chicken",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Beef",
    description: "beef",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Tofu",
    description: "tofu",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Egg",
    description: "egg",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Rice",
    description: "rice",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Beans",
    description: "beans",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Tomato",
    description: "tomato",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Lettuce",
    description: "lettuce",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Onion",
    description: "onion",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Carrot",
    description: "carrot",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Cucumber",
    description: "cucumber",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Potato",
    description: "potato",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Corn",
    description: "corn",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  },
  %Ingredient{
    name: "Peanut",
    description: "peanut",
    image_url: "/uploads/ingredient-01.png",
    is_verified: true,
    user_id: admin_user.id
  }
]

Enum.map(ingrediants, fn ingrediant ->
  Repo.insert!(ingrediant)
end)

tags = [
  %Tag{name: "vegetarian", user_id: admin_user.id},
  %Tag{name: "vegan", user_id: admin_user.id},
  %Tag{name: "gluten free", user_id: admin_user.id},
  %Tag{name: "low carb", user_id: admin_user.id},
  %Tag{name: "high carb", user_id: admin_user.id},
  %Tag{name: "keto", user_id: admin_user.id},
  %Tag{name: "paleo", user_id: admin_user.id},
  %Tag{name: "dairy free", user_id: admin_user.id},
  %Tag{name: "nut free", user_id: admin_user.id},
  %Tag{name: "soy free", user_id: admin_user.id},
  %Tag{name: "fish free", user_id: admin_user.id},
  %Tag{name: "egg free", user_id: admin_user.id},
  %Tag{name: "meat free", user_id: admin_user.id},
  %Tag{name: "seafood free", user_id: admin_user.id},
  %Tag{name: "shellfish free", user_id: admin_user.id},
  %Tag{name: "fruit free", user_id: admin_user.id},
  %Tag{name: "sugar free", user_id: admin_user.id},
  %Tag{name: "sweet free", user_id: admin_user.id},
  %Tag{name: "fat free", user_id: admin_user.id},
  %Tag{name: "cholesterol free", user_id: admin_user.id}
]

Enum.map(tags, fn tag ->
  Repo.insert!(tag)
end)
