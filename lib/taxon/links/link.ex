defmodule Taxon.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :destination, :string
    field :key, :string
    field :name, :string
    field :description, :string
    field :parser, Ecto.Enum, values: [default: 1, liquex: 2], default: :default
    field :parser_version, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:name, :key, :destination, :description, :parser, :parser_version])
    |> validate_required([:name, :key, :destination])
  end
end
