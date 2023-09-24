defmodule Mysulpak.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :desc, :text

      timestamps()
    end
  end
end
