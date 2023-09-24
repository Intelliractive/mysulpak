defmodule Mysulpak.Repo.Migrations.AddPicToItems do
  use Ecto.Migration

  def change do
    alter table("items") do
      add :picture, :string
    end
  end
end
