defmodule Taxon.Links.LinkViewCounter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "link_view_counters" do
    field :count, :integer, default: 0
    belongs_to :link, Taxon.Links.Link

    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:count])
    |> validate_required([:count])
  end
end
