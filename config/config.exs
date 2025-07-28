# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :scratch_app,
  ecto_repos: [ScratchApp.Repo],
  generators: [timestamp_type: :utc_datetime]

config :scratch_app, ScratchApp.Guardian,
  issuer: "scratch_app",
  secret_key: "bv+wBYUOq7M0I0kkm1bORHryUpmooBxKyBKyOoQGVoCQ6B+BF6zI7eHYAURxYCh2"

config :waffle, storage: Waffle.Storage.Local

config :cors_plug,
  origin: ["http://localhost:5173"],
  max_age: 86400,
  methods: ["GET", "POST"],
  credentials: true

# Configures the endpoint
config :scratch_app, ScratchAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: ScratchAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ScratchApp.PubSub,
  live_view: [signing_salt: "fclGnkTU"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :scratch_app, ScratchApp.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
