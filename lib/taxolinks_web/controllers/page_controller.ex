defmodule TaxolinksWeb.PageController do
  use TaxolinksWeb, :controller

  alias Taxolinks.Links
  alias Taxolinks.Links.Link

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def stuff(conn, params) do
    %{"path" => [key | pieces]} = params

    case Links.get_link_by_key(key) do
      nil ->
        redirect(conn, to: ~p"/links/new?key=#{key}")

      link ->
        redirect_url = build_redirect_url(link, pieces)

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
