defmodule Ctbc.Repo do
  use Ecto.Repo,
    otp_app: :ctbc,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
