defmodule PlaygroundWeb.TicketLive.Index do
  use PlaygroundWeb, :live_view

  alias Playground.Support

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:open_tickets, nil)
     |> assign(:closed_tickets, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Tickets
      <:subtitle>
        All open and closed tickets with their representative
      </:subtitle>
    </.header>

    <.table id="open_tickets" rows={@open_tickets}>
      <:col :let={ticket} label="ID">
        <.link navigate={~p"/tickets/#{ticket}"}>
          <%= ticket.id %>
        </.link>
      </:col>
      <:col :let={ticket} label="Subject"><%= ticket.subject %></:col>
      <:col :let={ticket} label="Representative">
        <.link
          navigate={~p"/representatives/#{ticket.representative}"}
          class="font-semibold hover:underline"
        >
          <%= ticket.representative.name %>
        </.link>
      </:col>
    </.table>
    <.table id="closed_tickets" rows={@closed_tickets}>
      <:col :let={ticket} label="ID">
        <.link navigate={~p"/tickets/#{ticket}"}>
          <%= ticket.id %>
        </.link>
      </:col>
      <:col :let={ticket} label="Subject"><%= ticket.subject %></:col>
      <:col :let={ticket} label="Representative">
        <.link
          navigate={~p"/representatives/#{ticket.representative}"}
          class="font-semibold hover:underline"
        >
          <%= ticket.representative.name %>
        </.link>
      </:col>
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
    |> assign_tickets()
  end

  defp assign_tickets(socket) do
    socket
    |> assign(:open_tickets, Support.all_open_tickets())
    |> assign(:closed_tickets, Support.all_closed_tickets())
  end
end
