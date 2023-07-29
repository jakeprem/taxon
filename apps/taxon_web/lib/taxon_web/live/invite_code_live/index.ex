defmodule TaxonWeb.InviteCodeLive.Index do
  use TaxonWeb, :live_view

  alias Taxon.Invites
  alias Taxon.Invites.InviteCode

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :invite_codes, Invites.list_invite_codes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Invite code")
    |> assign(:invite_code, Invites.get_invite_code!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Invite code")
    |> assign(:invite_code, %InviteCode{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Invite codes")
    |> assign(:invite_code, nil)
  end

  @impl true
  def handle_info({TaxonWeb.InviteCodeLive.FormComponent, {:saved, invite_code}}, socket) do
    {:noreply, stream_insert(socket, :invite_codes, invite_code)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    invite_code = Invites.get_invite_code!(id)
    {:ok, _} = Invites.delete_invite_code(invite_code)

    {:noreply, stream_delete(socket, :invite_codes, invite_code)}
  end
end
