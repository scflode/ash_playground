defmodule PlaygroundWeb.TicketLive.Index do
  use PlaygroundWeb, :live_view

  alias Playground.Support

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tickets, list_tickets())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Tickets
    </.header>

    <.table id="tickets" rows={@tickets} row_click={&JS.navigate(~p"/tickets/#{&1}")}>
      <:col :let={ticket} label="ID"><%= ticket.id %></:col>
      <:col :let={ticket} label="Subject"><%= ticket.subject %></:col>
      <:col :let={ticket} label="Representative"><%= ticket.representative.name %></:col>
    </.table>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tickets")
    |> assign(:ticket, nil)
  end

  defp list_tickets do
    Support.all_open_tickets()
  end
end
