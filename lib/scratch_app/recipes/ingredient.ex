defmodule ScratchApp.Recipes.Ingredient do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset
  alias ScratchApp.Recipes.Recipe

  schema "ingredients" do
    field :description, :string
    field :image, ScratchApp.MediaResourceManager.Type
    belongs_to :recipe, Recipe, foreign_key: :recipe_id
    timestamps()
  end

  @required ~w(description recipe_id)a
  @optional ~w(image)a
  @allowed @required ++ @optional

  @doc false
  def changeset(%__MODULE__{} = ingredient, attrs \\ %{}) do
    ingredient
    |> cast(attrs, @allowed)
    |> validate_required(@required)
    |> foreign_key_constraint(:recipe_id)
  end

  def new_changeset(%__MODULE__{} = ingredient, attrs \\ %{}, %{recipe_id: recipe_id}) do
    Map.put(ingredient, :scope_id, recipe_id)
    |> cast(attrs, [:description])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:description])
  end

  def cast_assoc_with_recipe(changeset, attrs, recipe_id) do
    changeset
    |> cast(attrs, [])
    |> cast_assoc(:ingredients,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end

  def cast_assoc_with_recipe(changeset, recipe_id) do
    changeset
    |> cast_assoc(:ingredients,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end
end
