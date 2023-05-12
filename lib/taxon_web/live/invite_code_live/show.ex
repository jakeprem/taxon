defmodule TaxonWeb.InviteCodeLive.Show do
  use TaxonWeb, :live_view

  alias Taxon.Invites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:invite_code, Invites.get_invite_code!(id))}
  end

  defp page_title(:show), do: "Show Invite code"
  defp page_title(:edit), do: "Edit Invite code"
end
