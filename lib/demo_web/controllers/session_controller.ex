# defmodule DemoWeb.SessionController do
#   use Phoenix.Controller

#   alias Demo.Users

#   def new(conn, _params) do
#     render(conn, "new.html")
#   end

#   def create(conn, %{"session" => %{"email" => email, "password" => password }}) do
#     case Users.authenticate(email, password) do
#       {:ok, user} ->
#       conn 
#       |> put_session(:current_user_id, user.id)
#       |> redirect(to: "/")
#       |> put_flash(:info, "Logged in successfully")
#     {:error, _} ->
#         conn
#         |> put_flash(:error, "Invalid email or password")
#         |> render("new.html")
#     end
#   end

#   def delete(conn, _params) do
#     conn
#     |> delete_session(:current_user_id)
#     |> redirect(to: "/")
#   end
  
# end