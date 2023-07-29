defmodule Taxon.Links do
  @moduledoc """
  The Links context.
  """
  use EctoResource

  alias Taxon.Repo
  alias Taxon.Links.Link

  using_repo(Repo) do
    resource(Link)
  end

  # mix phx.gen.live expects change_link/0 which EctoResource isn't creating by default
  def change_link(link), do: change_link(link, %{})

  # EctoResource does all_links instead of list_links
  def list_links, do: all_links()

  def get_link_by_key(key) do
    Repo.get_by(Link, key: key)
  end
end
