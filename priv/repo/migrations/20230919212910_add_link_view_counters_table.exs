defmodule Taxon.Repo.Migrations.AddLinkViewCountersTable do
  use Ecto.Migration

  def change do
    create table(:link_view_counters) do
      add :count, :integer, default: 0
      add :link_id, references(:links, on_delete: :delete_all, on_update: :update_all)

      timestamps()
    end

    create unique_index(:link_view_counters, [:link_id])
  end
end
