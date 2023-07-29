defmodule Taxon.Invites.InviteCode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invite_codes" do
    field :active, :boolean, default: false
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(invite_code, attrs) do
    invite_code
    |> cast(attrs, [:code, :active])
    |> validate_required([:code, :active])
  end
end
