defmodule Taxon.LinkExpander do
  alias Taxon.Links.Link

  def expand_link(link, pieces)

  def expand_link(%Link{parser: :liquex, destination: destination}, pieces) do
    with {:ok, template} <- Liquex.parse(destination),
         {result, _context} <- Liquex.render!(template, %{pieces: pieces}) do
      result
      |> to_string()
      |> String.trim()
    end
  end

  def expand_link(%Link{} = link, pieces) do
    Enum.reduce(pieces, link.destination, fn piece, acc ->
      String.replace(acc, "%s", piece, global: false)
    end)
  end
end
