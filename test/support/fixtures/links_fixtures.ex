defmodule Taxon.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Taxon.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        key: "elixir",
        destination: "some destination",
        name: "some name"
      })
      |> Taxon.Links.create_link()

    link
  end
end
