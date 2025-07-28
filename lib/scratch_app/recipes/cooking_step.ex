defmodule ScratchApp.Recipes.CookingStep do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset

  alias ScratchApp.Recipes.Recipe

  schema "cooking_steps" do
    field :step, :integer
    field :description, :string
    field :video, ScratchApp.MediaResourceManager.Type
    field :video_title, :string
    belongs_to :recipe, Recipe, foreign_key: :recipe_id
    timestamps()
  end

  @required ~w(step description recipe_id)a
  @optional ~w(video_title video)a
  @allowed @required ++ @optional

  @doc false
  def changeset(%__MODULE__{} = cooking_step, attrs \\ %{}) do
    cooking_step
    |> cast(attrs, @allowed)
    |> validate_required(@required)
    |> foreign_key_constraint(:recipe_id)
  end

  def new_changeset(%__MODULE__{} = cooking_step, attrs \\ %{}, %{recipe_id: recipe_id}) do
    Map.put(cooking_step, :scope_id, recipe_id)
    |> cast(attrs, [:step, :description, :video_title])
    |> cast_attachments(attrs, [:video])
    |> validate_required([:step, :description])
  end

  def cast_assoc_with_recipe(changeset, attrs, recipe_id) do
    changeset
    |> cast(attrs, [])
    |> cast_assoc(:cooking_steps,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end

  def cast_assoc_with_recipe(changeset, recipe_id) do
    changeset
    |> cast_assoc(:cooking_steps,
      required: true,
      with: {__MODULE__, :new_changeset, [%{recipe_id: recipe_id}]}
    )
  end
end
