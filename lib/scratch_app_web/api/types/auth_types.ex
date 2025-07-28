defmodule ScratchAppWeb.Types.AuthType do
  use Absinthe.Schema.Notation
  alias ScratchAppWeb.Resolvers.Auth
  import_types(ScratchAppWeb.Types.UserType)

  object :auth_mutations do
    @desc "Get Login"
    field :login, :auth_success do
      arg(:username, :string)
      arg(:email, :string)
      arg(:password, non_null(:string))
      resolve(&Auth.login/3)
    end

    @desc "Get Register"
    field :register, :auth_success do
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password_one, non_null(:string))
      arg(:password_two, non_null(:string))
      resolve(&Auth.register/3)
    end

    @desc "Get Refresh Token"
    field :refresh_token, :refresh_token_success do
      arg(:refresh_token, non_null(:string))
      resolve(&Auth.refresh_token/3)
    end
  end

  @desc "Refresh Token Successfull"
  object :refresh_token_success do
    field :access_token, :string
    field :refresh_token, :string
    field :exp, :integer
  end

  @desc "Auth Successfull"
  object :auth_success do
    field :id, :id
    field :access_token, :string
    field :refresh_token, :string
    field :user, :user
    field :exp, :integer
  end
end
