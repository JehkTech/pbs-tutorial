defmodule DemoWeb.TodoLive do
  use DemoWeb, :live_view
  import Phoenix.LiveView
  alias Demo.Todos
  require Logger


  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    if connected?(socket) do 
      Todos.subscribe(user.id)
    end

    {:ok, 
    socket
    |> assign(:page_title,"Todo List")
    |> assign(:todos, Todos.list_todos(user.id))
    |> assign(:edit_id, nil)}
  end

# Add action
  @impl Phoenix.LiveView
  def handle_event("add", %{"todo" => todo_params}, socket) do
    case Todos.create_todo(todo_params) do
      {:ok, _todo} ->
        {:noreply, fetch(socket)}
      {:error, changeset} ->
        Logger.error("Failed to create todo: #{inspect(changeset)}")
      {:noreply, put_flash(socket, :error, "Failed to create todo")}
    end
  end

# Delete action
  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    
    todo = Todos.get_todo!(id, user.id)
    case Todos.delete_todo(todo) do
      {:ok, _} ->
        {:noreply, fetch(socket)}
      {:error, changeset} ->
        Logger.error("Failed to delete todo: #{inspect(changeset)}")
        {:noreply, put_flash(socket, :error, "Failed to delete todo")}
    end
  end

# Edit action
@impl true
def handle_event("edit", %{"id" => id}, socket) do
  {:noreply, assign(socket, edit_id: String.to_integer(id))}
end

# Update action
@impl true
def handle_event("update", %{"id" => id, "todo" => todo_params}, socket) do
  user = socket.assigns.current_user

  todo = Todos.get_todo!(id, user.id)
  case Todos.update_todo(todo, todo_params) do
    {:ok, _todo} ->
      {:noreply, fetch(socket) |> assign(edit_id: nil)}
    {:error, changeset} ->
      Logger.error("Failed to update todo: #{inspect(changeset)}")
      {:noreply, put_flash(socket, :error, "Failed to update todo")}
  end
end

# Cancel edit action
@impl true
def handle_event("cancel_edit", _, socket) do
  {:noreply, assign(socket, edit_id: nil)}
end


@impl Phoenix.LiveView
def handle_info({Todos, [:todo | _], _}, socket) do
  {:noreply, fetch(socket)}
end

  # @impl true
  # def mount(_params, _session, socket) do
  #   form =
  #     %Post{}
  #     |> Post.changeset(%{})
  #     |> to_form(as: "post")

  #   socket =
  #     socket
  #     |> assign(form: form)
  #     |> allow_upload(:doc, accept: ~w(.txt), max_entries: 10)

  #   {:ok, socket}
  # end

  def fetch(socket) do
  user = socket.assigns.current_user
    todos = Demo.Todos.list_todos(user.id)
    socket
    |> assign(:todos, todos) 
    |> assign(:edit_id, nil)
  end
end
