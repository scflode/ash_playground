defmodule PlaygroundWeb.RepresentativeLive.Index do
  use PlaygroundWeb, :live_view

  alias Playground.Support

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :representatives, [])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Representatives
    </.header>

    <.table
      id="representatives"
      rows={@representatives}
      row_click={&JS.navigate(~p"/representatives/#{&1}")}
    >
      <:col :let={representative} label="ID"><%= representative.id %></:col>
      <:col :let={representative} label="Name"><%= representative.name %></:col>
      <:col :let={representative} label="Ratio"><%= representative.percent_open %></:col>
      <:col :let={representative} label="Open Tickets"><%= representative.open_tickets %></:col>
      <:col :let={representative} label="Total Tickets"><%= representative.total_tickets %></:col>
    </.table>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Representatives")
    |> assign(:representatives, list_representatives())
  end

  defp list_representatives do
    Support.all_active_representatives()
  end
end
