defmodule Taxon.Links do
  @moduledoc """
  The Links context.
  """
  use EctoResource

  import Ecto.Query

  alias Taxon.Repo
  alias Taxon.Links.Link
  alias Taxon.Links.LinkViewCounter

  using_repo(Repo) do
    resource(Link)
  end

  # mix phx.gen.live expects change_link/0 which EctoResource isn't creating by default
  def change_link(link), do: change_link(link, %{})

  def list_links_with_views do
    from(l in Link,
      left_join: lvc in assoc(l, :view_counter),
      order_by: [desc_nulls_last: lvc.count],
      select: %{l | views: lvc.count}
    )
    |> Repo.all()
  end

  def list_links, do: all_links()

  def get_link_by_key(key) do
    Repo.get_by(Link, key: key)
  end

  def increment_link_view_counter!(%Link{id: link_id}) do
    increment_link_view_counter!(link_id)
  end

  def increment_link_view_counter!(link_id) do
    case Repo.get_by(LinkViewCounter, link_id: link_id) do
      nil ->
        %LinkViewCounter{link_id: link_id}
        |> LinkViewCounter.changeset(%{count: 1})
        |> Repo.insert!()

      lvc ->
        # We could just do a direct update query and let the DB handle it
        lvc
        |> LinkViewCounter.changeset(%{count: lvc.count + 1})
        |> Repo.update!()
    end
  end
end
