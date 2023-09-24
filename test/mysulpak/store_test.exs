defmodule Mysulpak.StoreTest do
  use Mysulpak.DataCase

  alias Mysulpak.Store

  describe "items" do
    alias Mysulpak.Store.Item

    import Mysulpak.StoreFixtures

    @invalid_attrs %{desc: nil, name: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Store.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Store.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{desc: "some desc", name: "some name"}

      assert {:ok, %Item{} = item} = Store.create_item(valid_attrs)
      assert item.desc == "some desc"
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{desc: "some updated desc", name: "some updated name"}

      assert {:ok, %Item{} = item} = Store.update_item(item, update_attrs)
      assert item.desc == "some updated desc"
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_item(item, @invalid_attrs)
      assert item == Store.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Store.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Store.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Store.change_item(item)
    end
  end
end
