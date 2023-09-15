defmodule Ctbc.Repo do
  use Ecto.Repo,
    otp_app: :ctbc,
    adapter: Ecto.Adapters.Postgres
end
