defmodule LiveControls.Repo do
  use Ecto.Repo,
    otp_app: :live_controls,
    adapter: Ecto.Adapters.Postgres
end
