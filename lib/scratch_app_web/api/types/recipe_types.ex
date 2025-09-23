defmodule ScratchAppWeb.Types.RecipeType do
  use Absinthe.Schema.Notation

  alias ScratchAppWeb.Resolvers.{Recipe, Helpers}
  import_types(Absinthe.Plug.Types)

  object :recipe_mutations do
    @desc "Create Recipe"
    field :create_recipe, :create_recipe_success do
      arg(:name, non_null(:string))
      arg(:serve_time, non_null(:integer))
      arg(:category_id, :integer)
      arg(:nutrition_facts, non_null(list_of(:string)))
      arg(:cooking_steps, non_null(list_of(:cooking_step_input)))
      arg(:recipe_images, non_null(list_of(:recipe_image_input)))
      arg(:ingredients, non_null(list_of(:ingredient_input)))
      resolve(&Recipe.create_recipe/3)
    end

    @desc "Update Recipe"
    field :update_recipe, :create_recipe_success do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:category_id, :integer)
      arg(:serve_time, non_null(:integer))
      arg(:nutrition_facts, non_null(list_of(:string)))
      resolve(&Recipe.update_recipe/3)
    end

    @desc "Update Recipe Images"
    field :update_recipe_images, :update_recipe_images_success do
      arg(:id, non_null(:id))
      arg(:recipe_images, non_null(list_of(:recipe_image_input)))
      resolve(&Recipe.update_recipe_images/3)
    end

    @desc "Update Recipe Ingredients"
    field :update_recipe_ingredients, :update_recipe_ingredients_success do
      arg(:id, non_null(:id))
      arg(:ingredients, list_of(:ingredient_input))
      resolve(&Recipe.update_recipe_ingredients/3)
    end

    @desc "Update Recipe Cooking Steps"
    field :update_recipe_cooking_steps, :update_recipe_cooking_steps_success do
      arg(:id, non_null(:id))
      arg(:cooking_steps, list_of(:cooking_step_input))
      resolve(&Recipe.update_recipe_cooking_steps/3)
    end

    @desc "Like Recipe"
    field :like_recipe, :like_recipe_success do
      arg(:recipe_id, non_null(:id))
      resolve(&Recipe.like_recipe/3)
    end

    @desc "Create Ingredient"
    field :create_ingredient, :create_ingredient_success do
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))
      arg(:image_url, :upload)
      resolve(&Recipe.create_ingredient/3)
    end

    @desc "Create Tag"
    field :create_tag, :create_tag_success do
      arg(:name, non_null(:string))
      resolve(&Recipe.create_tag/3)
    end

    @desc "Create Category"
    field :create_category, :create_category_success do
      arg(:title, non_null(:string))
      resolve(&Recipe.create_category/3)
    end

    @desc "Save Recipe"
    field :save_recipe, :save_recipe_success do
      arg(:recipe_id, non_null(:id))
      arg(:category_id, non_null(:id))
      resolve(&Recipe.save_recipe_by_category/3)
    end
  end

  object :recipe_queries do
    @desc "Get Recipe"
    field :get_recipe, :recipe do
      arg(:id, non_null(:id))
      resolve(&Recipe.get_recipe/3)
    end

    @desc "Get Categories"
    field :categories, list_of(:category) do
      resolve(&Recipe.get_categories/3)
    end

    @desc "Get Ingredients"
    field :get_ingredients, list_of(:ingredient) do
      resolve(&Recipe.get_ingredients/3)
    end
  end

  input_object :ingredient_input do
    field :id, :id
    field :image, :upload
    field :description, non_null(:string)
  end

  input_object :cooking_step_input do
    field :step, non_null(:integer)
    field :description, non_null(:string)
    field :video, :upload
    field :video_title, :string
  end

  input_object :recipe_image_input do
    field :id, :id
    field :image, :upload
  end

  @desc "Create Recipe Successfull"
  object :create_recipe_success do
    field :id, :integer
    field :name, :string
    field :serve_time, :integer
    field :category_id, :integer
    field :nutrition_facts, :string
  end

  @desc "Update Recipe Ingredients Successfull"
  object :update_recipe_ingredients_success do
    field :ingredients, list_of(:ingredient)
  end

  @desc "Update Recipe Cooking Step Successfull"
  object :update_recipe_cooking_steps_success do
    field :cooking_steps, list_of(:cooking_step)
  end

  @desc "Update Recipe Images Successfull"
  object :update_recipe_images_success do
    field :recipe_images, list_of(:recipe_image)
  end

  @desc "Update Recipe Images Successfull"
  object :like_recipe_success do
    field :message, :string
  end

  @desc "Create Category Successfull"
  object :create_category_success do
    field :id, :integer
    field :title, :string
  end

  @desc "Create Ingredient Successfull"
  object :create_ingredient_success do
    field :id, :integer
    field :name, :string
    field :description, :string

    field :image_url, :string do
      resolve(&Helpers.resolve_ingredient_images/3)
    end
  end

  @desc "Create Tag Successfull"
  object :create_tag_success do
    field :id, :integer
    field :name, :string
  end

  @desc "Save Recipe By Category Successfull"
  object :save_recipe_success do
    field :id, :integer
    field :user_id, :integer
    field :recipe_id, :integer
    field :category_id, :integer
  end

  # @desc "Update Recipe Images Successfull"
  # object :update_recipe_success do
  #   field :recipe_images, list_of(:recipe_image)
  # end

  object :ingredient do
    field :id, :integer
    field :name, :string
    field :description, :string

    field :image_url, :string do
      resolve(&Helpers.resolve_ingredient_images/3)
    end
  end

  object :recipe_image do
    field :image_url, :string do
      resolve(&Helpers.resolve_images/3)
    end
  end

  object :cooking_step do
    field :step, :integer
    field :description, :string
    field :video_title, :string

    field :video_url, :string do
      resolve(&Helpers.resolve_videos/3)
    end
  end

  object :recipe do
    field :id, :id
    field :name, :string
    field :serve_time, :integer
    field :category_id, :integer
    field :nutrition_facts, :string
    field :ingredients, list_of(:ingredient)
    field :cooking_steps, list_of(:cooking_step)
    field :recipe_images, list_of(:recipe_image)
  end

  object :category do
    field :id, :id
    field :title, :string
  end
end
