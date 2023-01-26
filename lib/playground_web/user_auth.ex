defmodule PlaygroundWeb.UserAuth do
  use PlaygroundWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  def on_mount(:ensure_authenticated, _params, _session, socket) do
    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/login")

      {:halt, socket}
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end
end
