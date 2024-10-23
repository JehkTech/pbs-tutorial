defmodule DemoWeb.LinkLive.Index do
  use DemoWeb, :live_view

  alias Demo.Links

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    user_id = user.id

    socket =
      socket
      |> assign(:links, Links.list_links_by_user(user_id))

    {:ok, socket}
  end

end
