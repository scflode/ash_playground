defmodule PlaygroundWeb.AuthController do
  use PlaygroundWeb, :controller
  use AshAuthentication.Phoenix.Controller

  @impl true
  def success(conn, _activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: return_to)
  end

  @impl true
  def failure(conn, _activity, reason) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Login failed: #{inspect(reason)}")
    |> redirect(to: ~p"/")
  end

  @impl true
  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session()
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: return_to)
  end
end
