defmodule MysulpakWeb.ItemLive.Index do
  use MysulpakWeb, :live_view

  alias Mysulpak.Store
  alias Mysulpak.Store.Item

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
    |> stream(:items, Store.list_items())
  }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Изменение товара")
    |> assign(:item, Store.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Создание товара")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Магазин")
    |> assign(:item, nil)
  end

  @impl true
  def handle_info({MysulpakWeb.ItemLive.FormComponent, {:saved, item}}, socket) do
    {:noreply, stream_insert(socket, :items, item)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Store.get_item!(id)
    {:ok, _} = Store.delete_item(item)

    {:noreply, stream_delete(socket, :items, item)}
  end
end
