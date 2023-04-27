defmodule TaxonWeb.InviteCodeLiveTest do
  use TaxonWeb.ConnCase

  import Phoenix.LiveViewTest
  import Taxon.InvitesFixtures

  @create_attrs %{active: true, code: "some code"}
  @update_attrs %{active: false, code: "some updated code"}
  @invalid_attrs %{active: false, code: nil}

  defp create_invite_code(_) do
    invite_code = invite_code_fixture()
    %{invite_code: invite_code}
  end

  describe "Index" do
    setup [:create_invite_code]

    test "lists all invite_codes", %{conn: conn, invite_code: invite_code} do
      {:ok, _index_live, html} = live(conn, ~p"/invite_codes")

      assert html =~ "Listing Invite codes"
      assert html =~ invite_code.code
    end

    test "saves new invite_code", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/invite_codes")

      assert index_live |> element("a", "New Invite code") |> render_click() =~
               "New Invite code"

      assert_patch(index_live, ~p"/invite_codes/new")

      assert index_live
             |> form("#invite_code-form", invite_code: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invite_code-form", invite_code: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invite_codes")

      html = render(index_live)
      assert html =~ "Invite code created successfully"
      assert html =~ "some code"
    end

    test "updates invite_code in listing", %{conn: conn, invite_code: invite_code} do
      {:ok, index_live, _html} = live(conn, ~p"/invite_codes")

      assert index_live |> element("#invite_codes-#{invite_code.id} a", "Edit") |> render_click() =~
               "Edit Invite code"

      assert_patch(index_live, ~p"/invite_codes/#{invite_code}/edit")

      assert index_live
             |> form("#invite_code-form", invite_code: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invite_code-form", invite_code: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invite_codes")

      html = render(index_live)
      assert html =~ "Invite code updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes invite_code in listing", %{conn: conn, invite_code: invite_code} do
      {:ok, index_live, _html} = live(conn, ~p"/invite_codes")

      assert index_live |> element("#invite_codes-#{invite_code.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#invite_codes-#{invite_code.id}")
    end
  end

  describe "Show" do
    setup [:create_invite_code]

    test "displays invite_code", %{conn: conn, invite_code: invite_code} do
      {:ok, _show_live, html} = live(conn, ~p"/invite_codes/#{invite_code}")

      assert html =~ "Show Invite code"
      assert html =~ invite_code.code
    end

    test "updates invite_code within modal", %{conn: conn, invite_code: invite_code} do
      {:ok, show_live, _html} = live(conn, ~p"/invite_codes/#{invite_code}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Invite code"

      assert_patch(show_live, ~p"/invite_codes/#{invite_code}/show/edit")

      assert show_live
             |> form("#invite_code-form", invite_code: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#invite_code-form", invite_code: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/invite_codes/#{invite_code}")

      html = render(show_live)
      assert html =~ "Invite code updated successfully"
      assert html =~ "some updated code"
    end
  end
end
