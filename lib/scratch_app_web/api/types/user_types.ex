defmodule ScratchAppWeb.Types.UserType do
  use Absinthe.Schema.Notation
  alias ScratchAppWeb.Resolvers.Users

  object :user_queries do
    @desc "Get All Users"
    field :users, list_of(:user) do
      resolve(&Users.list_users/2)
    end

    field :get_user_info, :user do
      resolve(&Users.get_user/2)
    end
  end

  object :user_mutations do
    @desc "Follow User"
    field :follow_user, :follow_user_success do
      arg(:following_id, non_null(:id))
      resolve(&Users.follow_user/2)
    end
  end

  @desc "A User"
  object :user do
    field :id, :id
    field :email, :string
    field :age, :string
    field :username, :string
  end

  @desc "Follow User Successfully"
  object :follow_user_success do
    field :message, :string
  end
end
