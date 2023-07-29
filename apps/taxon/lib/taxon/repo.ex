defmodule Taxon.Repo do
  use Ecto.Repo,
    otp_app: :taxon,
    adapter: Ecto.Adapters.SQLite3
end
