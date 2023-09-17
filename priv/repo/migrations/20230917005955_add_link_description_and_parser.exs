defmodule Taxon.Repo.Migrations.AddLinkDescriptionAndParser do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :description, :text
      add :parser, :integer
      add :parser_version, :integer
    end
  end
end
