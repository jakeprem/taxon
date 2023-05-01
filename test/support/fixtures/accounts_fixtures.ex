defmodule Taxon.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Taxon.Accounts` context.
  """

  alias Taxon.InvitesFixtures

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    invite_code = InvitesFixtures.invite_code_fixture()

    {:ok, user} =
      attrs
      |> Enum.into(%{invite_code: invite_code.code})
      |> valid_user_attributes()
      |> Taxon.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
