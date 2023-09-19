defmodule Taxon.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :destination, :string
    field :key, :string
    field :name, :string

    field :views, :integer, virtual: true

    has_one :view_counter, Taxon.Links.LinkViewCounter

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:name, :key, :destination])
    |> validate_required([:name, :key, :destination])
  end
end
