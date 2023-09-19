defmodule Taxon.Links.CounterSupervisor do
  @moduledoc """
  Exists solely to increment the count of views on a link asynchronously.

  Literally just so we can redirect the user without waiting for this to finish.
  """

  alias Taxon.Links
  alias Taxon.Links.Link

  @doc """
  Starts a task that will increment the view count for this link.
  """
  def start_view_increment(link_or_link_id)

  def start_view_increment(%Link{id: link_id}) do
    start_view_increment(link_id)
  end

  def start_view_increment(link_id) do
    Task.Supervisor.start_child(__MODULE__, fn ->
      Links.increment_link_view_counter!(link_id)
    end)
  end
end
