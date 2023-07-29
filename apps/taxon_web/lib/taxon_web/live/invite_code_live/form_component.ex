defmodule TaxonWeb.InviteCodeLive.FormComponent do
  use TaxonWeb, :live_component

  alias Taxon.Invites

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage invite_code records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="invite_code-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:code]} type="text" label="Code" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Invite code</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{invite_code: invite_code} = assigns, socket) do
    changeset = Invites.change_invite_code(invite_code)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"invite_code" => invite_code_params}, socket) do
    changeset =
      socket.assigns.invite_code
      |> Invites.change_invite_code(invite_code_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"invite_code" => invite_code_params}, socket) do
    save_invite_code(socket, socket.assigns.action, invite_code_params)
  end

  defp save_invite_code(socket, :edit, invite_code_params) do
    case Invites.update_invite_code(socket.assigns.invite_code, invite_code_params) do
      {:ok, invite_code} ->
        notify_parent({:saved, invite_code})

        {:noreply,
         socket
         |> put_flash(:info, "Invite code updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_invite_code(socket, :new, invite_code_params) do
    case Invites.create_invite_code(invite_code_params) do
      {:ok, invite_code} ->
        notify_parent({:saved, invite_code})

        {:noreply,
         socket
         |> put_flash(:info, "Invite code created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
