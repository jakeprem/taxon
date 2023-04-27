defmodule TaxolinksWeb.PageController do
  use TaxolinksWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def stuff(conn, params) do
    %{"path" => [key | pieces]} = params
    render(conn, :stuff, params: %{key: key, pieces: pieces})
  end
end
