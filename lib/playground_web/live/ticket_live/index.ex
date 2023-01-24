defmodule PlaygroundWeb.TicketLive.Index do
  use PlaygroundWeb, :live_view

  alias Playground.Support
  alias PlaygroundWeb.Components.Pagination

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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

    <.simple_form :let={f} for={:filter} phx-change="filter">
      <.input
        field={{f, :status}}
        type="select"
        options={[{"All", :all}, {"Open", :open}, {"Closed", :closed}]}
      />
    </.simple_form>

    <.table id="tickets" rows={@tickets}>
      <:col :let={ticket} label="ID">
        <.link navigate={~p"/tickets/#{ticket}"}>
          <%= ticket.id %>
        </.link>
      </:col>
      <:col :let={ticket} label="Subject"><%= ticket.subject %></:col>
      <:col :let={ticket} label="Status"><%= ticket.status %></:col>
      <:col :let={ticket} label="Representative">
        <.link
          :if={ticket.representative}
          navigate={~p"/representatives/#{ticket.representative}"}
          class="font-semibold hover:underline"
        >
          <%= ticket.representative.name %>
        </.link>
      </:col>
    </.table>
    <Pagination.default
      current_start={@offset}
      current_end={@offset + @limit}
      total_items={@count}
      path={~p"/tickets?#{@filters}"}
    />
    """
  end

  @impl true
  def handle_event("filter", %{"filter" => filters}, socket) do
    filters =
      Enum.reject(filters, fn filter ->
        case filter do
          {"status", "all"} -> true
          _ -> false
        end
      end)

    {:noreply,
     socket
     |> push_patch(to: ~p"/tickets?#{filters}")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    page = (params["page"] || "1") |> String.to_integer()
    status = (params["status"] || "all") |> String.to_existing_atom()

    socket
    |> assign(:page_title, "Listing Tickets")
    |> assign_tickets(page, status)
    |> assign_filters(status)
  end

  defp assign_tickets(socket, page, status) do
    new_offset =
      case page do
        1 -> 0
        page -> 10 * (page - 1)
      end

    tickets = Support.filter_tickets_by_status(new_offset, status)

    socket
    |> assign(:tickets, tickets.results)
    |> assign(:count, tickets.count)
    |> assign(:offset, tickets.offset)
    |> assign(:limit, tickets.limit)
  end

  defp assign_filters(socket, status) do
    filters =
      %{}
      |> maybe_set_status(status)

    socket
    |> assign(:status, status)
    |> assign(:filters, filters)
  end

  defp maybe_set_status(filters, :all), do: filters
  defp maybe_set_status(filters, status), do: Enum.into(filters, %{status: status})
end
