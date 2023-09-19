defmodule TaxonWeb.PageController do
  use TaxonWeb, :controller

  alias Taxon.Links.CounterSupervisor
  alias Taxon.Links
  alias Taxon.Links.Link

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false, user: conn.assigns.current_user)
    redirect(conn, to: "/links")
  end

  def execute_link(conn, params) do
    %{"path" => [key | pieces]} = params

    case Links.get_link_by_key(key) do
      nil ->
        redirect(conn, to: ~p"/links/new?key=#{key}")

      link ->
        redirect_url = build_redirect_url(link, pieces)

        CounterSupervisor.start_view_increment(link)

        conn
        |> redirect(external: redirect_url)
    end
  end

  def build_redirect_url(%Link{} = link, pieces) do
    Enum.reduce(pieces, link.destination, fn piece, acc ->
      String.replace(acc, "%s", piece, global: false)
    end)
  end
end
