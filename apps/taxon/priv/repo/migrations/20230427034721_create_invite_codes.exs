defmodule Taxon.Repo.Migrations.CreateInviteCodes do
  use Ecto.Migration

  def change do
    create table(:invite_codes) do
      add :code, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end
  end
end
