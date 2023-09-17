defmodule TaxonWeb.PageController do
  use TaxonWeb, :controller

  alias Taxon.LinkExpander
  alias Taxon.Links

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
        redirect_url = LinkExpander.expand_link(link, pieces)

        redirect(conn, external: redirect_url)
    end
  end
end
