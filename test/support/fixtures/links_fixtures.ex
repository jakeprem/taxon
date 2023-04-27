defmodule Taxolinks.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Taxolinks.Links` context.
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
      |> Taxolinks.Links.create_link()

    link
  end
end
