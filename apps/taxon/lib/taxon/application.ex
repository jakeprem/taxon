defmodule Taxon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Taxon.Release.migrate()

    children = [
      # Start the Ecto repository
      Taxon.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Taxon.PubSub},
      # Start Finch
      {Finch, name: Taxon.Finch}
      # Start a worker by calling: Taxon.Worker.start_link(arg)
      # {Taxon.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Taxon.Supervisor)
  end
end
