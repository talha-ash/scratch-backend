defmodule ScratchAppWeb.Resolvers.Recipe do
  alias ScratchApp.Recipes

  def create_recipe(_parent, args, %{context: %{current_user: current_user}}) do
    args = Map.put(args, :user_id, current_user.id)

    with {:ok, %Recipes.Recipe{} = recipe} <- Recipes.create_recipe(args) do
      {:ok, recipe}
    else
      {:error, changeset} ->
        {:error, changeset}

      _ ->
        {:error, %{message: "Something went wrong"}}
    end
  end

  def update_recipe(_parent, args, %{context: %{current_user: _current_user}}) do
    with {:ok, %Recipes.Recipe{} = recipe} <-
           Recipes.update_recipe(args) do
      {:ok, recipe}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_recipe_ingredients(_parent, args, %{context: %{current_user: _current_user}}) do
    with {:ok, %Recipes.Recipe{} = recipe} <-
           Recipes.update_recipe_ingredients(args.id, Map.delete(args, :id)) do
      {:ok, %{ingredients: recipe.ingredients}}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_recipe_cooking_steps(_parent, args, %{context: %{current_user: _current_user}}) do
    with {:ok, %Recipes.Recipe{} = recipe} <-
           Recipes.update_recipe_cooking_steps(args.id, Map.delete(args, :id)) do
      {:ok, %{cooking_steps: recipe.cooking_steps}}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_recipe_images(_parent, args, %{context: %{current_user: _current_user}}) do
    with {:ok, %Recipes.Recipe{} = recipe} <-
           Recipes.update_recipe_images(args.id, Map.delete(args, :id)) do
      {:ok, %{recipe_images: recipe.recipe_images}}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_recipe(_parent, args, %{context: %{current_user: current_user}}) do
    args = Map.put(args, :user_id, current_user.id)

    recipe = Recipes.get_recipe(args.id)
    {:ok, recipe}
  end

  def like_recipe(_parent, args, %{context: %{current_user: current_user}}) do
    args = Map.put(args, :user_id, current_user.id)

    with nil <- Recipes.get_like_recipe(args),
         {:ok, %Recipes.Like{} = _recipe} <-
           Recipes.like_recipe(args) do
      {:ok, %{message: "like successfully"}}
    else
      %Recipes.Like{} = recipe_like ->
        Recipes.unlike_recipe(recipe_like)
        {:ok, %{message: "unlike successfully"}}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_category(_parent, args, %{context: %{current_user: current_user}}) do
    args = Map.put(args, :user_id, current_user.id)

    with {:ok, %Recipes.Category{} = category} <-
           Recipes.create_category(args) do
      {:ok, category}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def save_recipe_by_category(_parent, args, %{context: %{current_user: current_user}}) do
    args = Map.put(args, :user_id, current_user.id)

    with {:ok, %Recipes.SavedRecipe{} = saved_recipe} <-
           Recipes.save_recipe_by_category(args) do
      {:ok, saved_recipe}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_categories(_parent, args, %{context: %{current_user: current_user}}) do
    _args = Map.put(args, :user_id, current_user.id)

    {:ok, Recipes.get_categories(current_user.id)}
  end
end
