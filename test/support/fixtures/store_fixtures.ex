defmodule Mysulpak.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mysulpak.Store` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        desc: "some desc",
        name: "some name"
      })
      |> Mysulpak.Store.create_item()

    item
  end
end
