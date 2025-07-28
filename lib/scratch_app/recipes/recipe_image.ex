defmodule ScratchApp.Recipes.RecipeImage do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset
  alias ScratchApp.Recipes.Recipe

  schema "recipe_images" do
    field :image, ScratchApp.MediaResourceManager.Type
    belongs_to :recipe, Recipe, foreign_key: :recipe_id
    timestamps()
  end

  @required ~w(image recipe_id)a

  # @allowed @required ++ @optional

  @doc false
  def changeset(%__MODULE__{} = recipe_image, attrs) do
    recipe_image
    |> cast_attachments(attrs, [:image], allow_urls: true)
    |> validate_required(@required)
    |> foreign_key_constraint(:recipe_id)
  end

  def new_changeset(%__MODULE__{} = recipe_image, attrs \\ %{}, %{recipe_id: recipe_id}) do
    Map.put(recipe_image, :scope_id, recipe_id)
    |> cast_attachments(attrs, [:image], allow_urls: true)
    |> validate_required([:image])
  end

  def cast_assoc_with_recipe(changeset, attrs, recipe_id) do
    changeset
    |> cast(attrs, [])
    |> cast_assoc(:recipe_images,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end

  def cast_assoc_with_recipe(changeset, recipe_id) do
    changeset
    |> cast_assoc(:recipe_images,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end
end
