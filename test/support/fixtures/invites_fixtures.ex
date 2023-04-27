defmodule Taxon.InvitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Taxon.Invites` context.
  """

  @doc """
  Generate a invite_code.
  """
  def invite_code_fixture(attrs \\ %{}) do
    {:ok, invite_code} =
      attrs
      |> Enum.into(%{
        active: true,
        code: "some code"
      })
      |> Taxon.Invites.create_invite_code()

    invite_code
  end
end
