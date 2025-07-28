defmodule ScratchApp.Recipes.Category do
  use Ecto.Schema

  import Ecto.Changeset
  alias ScratchApp.Recipes.Recipe

  schema "categories" do
    field :title, :string

    belongs_to :user, User, foreign_key: :user_id
    has_many(:recipes, Recipe, on_replace: :delete)
    timestamps()
  end

  @required ~w(title user_id)a

  @doc false
  def changeset(%__MODULE__{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:title, :user_id])
  end
end
