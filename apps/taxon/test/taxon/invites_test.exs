defmodule Taxon.InvitesTest do
  use Taxon.DataCase

  alias Taxon.Invites

  describe "invite_codes" do
    alias Taxon.Invites.InviteCode

    import Taxon.InvitesFixtures

    @invalid_attrs %{active: nil, code: nil}

    test "list_invite_codes/0 returns all invite_codes" do
      invite_code = invite_code_fixture()
      assert Invites.list_invite_codes() == [invite_code]
    end

    test "get_invite_code!/1 returns the invite_code with given id" do
      invite_code = invite_code_fixture()
      assert Invites.get_invite_code!(invite_code.id) == invite_code
    end

    test "create_invite_code/1 with valid data creates a invite_code" do
      valid_attrs = %{active: true, code: "some code"}

      assert {:ok, %InviteCode{} = invite_code} = Invites.create_invite_code(valid_attrs)
      assert invite_code.active == true
      assert invite_code.code == "some code"
    end

    test "create_invite_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invites.create_invite_code(@invalid_attrs)
    end

    test "update_invite_code/2 with valid data updates the invite_code" do
      invite_code = invite_code_fixture()
      update_attrs = %{active: false, code: "some updated code"}

      assert {:ok, %InviteCode{} = invite_code} = Invites.update_invite_code(invite_code, update_attrs)
      assert invite_code.active == false
      assert invite_code.code == "some updated code"
    end

    test "update_invite_code/2 with invalid data returns error changeset" do
      invite_code = invite_code_fixture()
      assert {:error, %Ecto.Changeset{}} = Invites.update_invite_code(invite_code, @invalid_attrs)
      assert invite_code == Invites.get_invite_code!(invite_code.id)
    end

    test "delete_invite_code/1 deletes the invite_code" do
      invite_code = invite_code_fixture()
      assert {:ok, %InviteCode{}} = Invites.delete_invite_code(invite_code)
      assert_raise Ecto.NoResultsError, fn -> Invites.get_invite_code!(invite_code.id) end
    end

    test "change_invite_code/1 returns a invite_code changeset" do
      invite_code = invite_code_fixture()
      assert %Ecto.Changeset{} = Invites.change_invite_code(invite_code)
    end
  end
end
