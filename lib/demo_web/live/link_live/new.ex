defmodule DemoWeb.LinkLive.New do
  use DemoWeb, :live_view

  alias Demo.Links

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    changeset = Links.Link.changeset(%Links.Link{})

    socket =
      socket
      |> assign(
        :form,
        to_form(changeset)
      )

    {:ok, socket}
  end

  def handle_event("save", %{"link" => link_params}, socket) do
    params = link_params
    |> Map.put("user_id", socket.assigns.current_user.id)

    case Links.create_link(params) do
      {:ok, _link} ->
        socket =
          socket
          |> put_flash(:info, "Successfully Added Task.")
          |> push_navigate(to: ~p"/links")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(
            :form,
            to_form(changeset)
          )
          |> put_flash(:info, "Error, Link not created")

        {:noreply, socket}
    end
  end
end
