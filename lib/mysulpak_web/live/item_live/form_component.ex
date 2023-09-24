defmodule MysulpakWeb.ItemLive.FormComponent do
  use MysulpakWeb, :live_component

  alias Mysulpak.Store

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
          <:subtitle>Форма изменения\добавления товара</:subtitle>
      </.header>

      <.simple_form for={@form} id="item-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.live_file_input upload={@uploads.picture} />
        <%!-- use phx-drop-target with the upload ref to enable file drag and drop --%>
        <%!-- <section phx-drop-target={@uploads.picture.ref}>
        </section> --%>
          <%= for entry <- @uploads.picture.entries do %>
                <progress value={entry.progress} max="100">
                  <%= entry.progress %>%
                </progress>

                <button type="button" phx-click="cancel-upload" phx-value-ref={entry.ref} aria-label="cancel">&times;</button>

                <%= for err <- upload_errors(@uploads.picture, entry) do %>
                  <p class="alert alert-danger">
                    <%= error_to_string(err) %>
                  </p>
                <% end %>
              <% end %>
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:desc]} type="text" label="Desc" />

        <:actions>
          <.button phx-disable-with="Saving...">Сохранить</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Store.change_item(item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(:picture, accept: ~w(.png .jpg), max_entries: 1, auto_upload: true)}
  end

  @impl true
  def handle_event("validate", %{"item" => item_params}, socket) do
    changeset =
      socket.assigns.item
      |> Store.change_item(item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :picture, ref)}
  end

  def handle_event("save", %{"item" => item_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :picture, fn %{path: path}, _entry ->
        dest = Path.join("priv/status/uploads", Path.basename(path))
        # The `static/uploads` directory must exist for `File.cp!/2`
        # and MyAppWeb.static_paths/0 should contain uploads to work,.
        File.cp!(path, dest)
        {:ok, Path.basename(dest)}
      end)

    # update(socket, :uploaded_files, &(&1 ++ uploaded_files))
    item_params = Map.put(item_params, "picture", Enum.at(uploaded_files, 0))
    dbg(item_params)
    save_item(socket, socket.assigns.action, item_params)
  end

  defp save_item(socket, :edit, item_params) do
    case Store.update_item(socket.assigns.item, item_params) do
      {:ok, item} ->
        notify_parent({:saved, item})

        {:noreply,
         socket
         |> put_flash(:info, "Item updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_item(socket, :new, item_params) do
    case Store.create_item(item_params) do
      {:ok, item} ->
        notify_parent({:saved, item})

        {:noreply,
         socket
         |> put_flash(:info, "Item created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"
end
