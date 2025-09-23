defmodule ScratchAppWeb.Router do
  use ScratchAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/api", ScratchAppWeb do
    pipe_through :api
  end

  pipeline :auth_api do
    plug :accepts, ["json"]

    plug Guardian.Plug.Pipeline,
      module: ScratchApp.Guardian,
      error_handler: ScratchApp.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  pipeline :graphql do
    plug ScratchAppWeb.Context
    # plug ScratchAppWeb.GqlUpload
  end

  scope "/api/v1" do
    post "/login", ScratchAppWeb.AuthController, :login
    post "/register", ScratchAppWeb.AuthController, :register
    get "/refresh_token", ScratchAppWeb.AuthController, :refresh_token

    pipe_through :graphql
    post("/", Absinthe.Plug, schema: ScratchAppWeb.Schema)
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: ScratchAppWeb.Schema)

    pipe_through :auth_api
    get "/users", ScratchAppWeb.AuthController, :get_users
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:scratch_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ScratchAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
