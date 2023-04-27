defmodule Taxolinks.Repo do
  use Ecto.Repo,
    otp_app: :taxolinks,
    adapter: Ecto.Adapters.SQLite3
end
