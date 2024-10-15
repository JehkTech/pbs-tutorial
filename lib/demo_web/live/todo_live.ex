defmodule DemoWeb.TodoLive do
  use DemoWeb, :live_view
  alias Demo.Todos

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    Todos.subscribe()

    {:ok, fetch(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("add", %{"title" => title}, socket) do
    Todos.create_todo(%{title: title})
    {:noreply, fetch(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(id)
    {:noreply, fetch(socket)}
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

  defp fetch(socket) do
    assign(socket, todos: Todos.list_todos())
  end
end
