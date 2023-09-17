defmodule TaxonWeb.LinkLive.FormComponent do
  use TaxonWeb, :live_component

  alias Taxon.Links
  alias Taxon.Links.Link

  @parser_options Ecto.Enum.values(Link, :parser)

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage link records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="link-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:key]} type="text" label="Key" />
        <.input field={@form[:description]} type="text" label="Description" />
        <%= if @destination_field_type == "textarea" do %>
          <.input field={@form[:destination]} type="textarea" label="Destination" rows="4" />
        <% else %>
          <.input field={@form[:destination]} type="text" label="Destination" />
        <% end %>
        <details>
          <summary>Parser Options</summary>
          <.input field={@form[:parser]} type="select" options={@parser_options} label="Parser" />
          <.input field={@form[:parser_version]} type="number" label="Parser Version" />
        </details>
        <:actions>
          <.button phx-disable-with="Saving...">Save Link</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{link: link} = assigns, socket) do
    changeset = Links.change_link(link)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(parser_options: @parser_options)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"link" => link_params}, socket) do
    changeset =
      socket.assigns.link
      |> Links.change_link(link_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"link" => link_params}, socket) do
    save_link(socket, socket.assigns.action, link_params)
  end

  defp save_link(socket, :edit, link_params) do
    case Links.update_link(socket.assigns.link, link_params) do
      {:ok, link} ->
        notify_parent({:saved, link})

        {:noreply,
         socket
         |> put_flash(:info, "Link updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_link(socket, :new, link_params) do
    case Links.create_link(link_params) do
      {:ok, link} ->
        notify_parent({:saved, link})

        {:noreply,
         socket
         |> put_flash(:info, "Link created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
    |> assign(:destination_field_type, destination_field_type(changeset))
  end

  defp destination_field_type(changeset) do
    import Ecto.Changeset

    case get_field(changeset, :parser) do
      :liquex -> "textarea"
      _ -> "text"
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
