defmodule Mysulpak.Store.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :desc, :string
    field :name, :string
    field :picture, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :desc, :picture])
    |> validate_required([:name])
  end
end
