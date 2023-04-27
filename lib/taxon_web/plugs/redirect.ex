defmodule TaxonWeb.Redirect do
  @moduledoc """
  A plug to allow redirects directly in a router.
  """
  def init(opts) do
    case Keyword.has_key?(opts, :to) do
      true -> opts
      false -> raise ArgumentError, "The :to option is required"
    end
  end

  def call(conn, opts) do
    Phoenix.Controller.redirect(conn, opts)
  end
end
