defmodule Taxon.LinksTest do
  use Taxon.DataCase

  alias Taxon.Links

  describe "links" do
    alias Taxon.Links.Link

    import Taxon.LinksFixtures

    @invalid_attrs %{destination: nil, name: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{destination: "some destination", name: "some name", key: "some key"}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.destination == "some destination"
      assert link.name == "some name"
      assert link.key == "some key"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        destination: "some updated destination",
        name: "some updated name",
        key: "some updated key"
      }

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.destination == "some updated destination"
      assert link.name == "some updated name"
      assert link.key == "some updated key"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
