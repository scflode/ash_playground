defmodule PlaygroundWeb.AuthController do
  use PlaygroundWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, _activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: return_to)
  end

  def failure(conn, _activity, reason) do
    conn
    |> put_status(401)
    |> assign(:failure_reason, reason)
    |> render("failure.html")
  end

  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/login"

    conn
    |> clear_session()
    |> redirect(to: return_to)
  end
end
