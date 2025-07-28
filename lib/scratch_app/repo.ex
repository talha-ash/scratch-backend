defmodule ScratchApp.Repo do
  use Ecto.Repo,
    otp_app: :scratch_app,
    adapter: Ecto.Adapters.Postgres
end
