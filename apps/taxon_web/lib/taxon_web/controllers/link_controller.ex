defmodule TaxonWeb.LinkController do
  use TaxonWeb, :controller

  alias Taxon.Links
  alias Taxon.Links.Link

  def index(conn, params) do
    %{"path" => [key | pieces]} = params

    case get_link_by_key(key) do
      nil ->
        redirect(conn, to: ~p"/links/new?key=#{key}")

      link ->
        redirect_url = build_redirect_url(link, pieces)

        conn
        |> redirect(external: redirect_url)
    end
  end

  defp get_link_by_key(key) do
    Links.get_link_by_key(key)
  end

  def build_redirect_url(%Link{} = link, pieces) do
    Enum.reduce(pieces, link.destination, fn piece, acc ->
      String.replace(acc, "%s", piece, global: false)
    end)
  end
end
