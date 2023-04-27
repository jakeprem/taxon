defmodule Taxolinks.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :name, :string
      add :destination, :string
      add :key, :string

      timestamps()
    end
  end
end
