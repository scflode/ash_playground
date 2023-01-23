defmodule PlaygroundWeb.TicketLiveTest do
  use PlaygroundWeb.ConnCase

  import Phoenix.LiveViewTest
  import Playground.SupportFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_ticket(_) do
    ticket = ticket_fixture()
    %{ticket: ticket}
  end

  describe "Index" do
    setup [:create_ticket]

    test "lists all tickets", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/tickets")

      assert html =~ "Listing Tickets"
    end

    test "saves new ticket", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tickets")

      assert index_live |> element("a", "New Ticket") |> render_click() =~
               "New Ticket"

      assert_patch(index_live, ~p"/tickets/new")

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticket-form", ticket: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tickets")

      assert html =~ "Ticket created successfully"
    end

    test "updates ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, ~p"/tickets")

      assert index_live |> element("#tickets-#{ticket.id} a", "Edit") |> render_click() =~
               "Edit Ticket"

      assert_patch(index_live, ~p"/tickets/#{ticket}/edit")

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticket-form", ticket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tickets")

      assert html =~ "Ticket updated successfully"
    end

    test "deletes ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, ~p"/tickets")

      assert index_live |> element("#tickets-#{ticket.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ticket-#{ticket.id}")
    end
  end

  describe "Show" do
    setup [:create_ticket]

    test "displays ticket", %{conn: conn, ticket: ticket} do
      {:ok, _show_live, html} = live(conn, ~p"/tickets/#{ticket}")

      assert html =~ "Show Ticket"
    end

    test "updates ticket within modal", %{conn: conn, ticket: ticket} do
      {:ok, show_live, _html} = live(conn, ~p"/tickets/#{ticket}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ticket"

      assert_patch(show_live, ~p"/tickets/#{ticket}/show/edit")

      assert show_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ticket-form", ticket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tickets/#{ticket}")

      assert html =~ "Ticket updated successfully"
    end
  end
end
