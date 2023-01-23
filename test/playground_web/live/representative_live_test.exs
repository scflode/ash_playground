defmodule PlaygroundWeb.RepresentativeLiveTest do
  use PlaygroundWeb.ConnCase

  import Phoenix.LiveViewTest
  import Playground.SupportFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_representative(_) do
    representative = representative_fixture()
    %{representative: representative}
  end

  describe "Index" do
    setup [:create_representative]

    test "lists all representatives", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/representatives")

      assert html =~ "Listing Representatives"
    end

    test "saves new representative", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/representatives")

      assert index_live |> element("a", "New Representative") |> render_click() =~
               "New Representative"

      assert_patch(index_live, ~p"/representatives/new")

      assert index_live
             |> form("#representative-form", representative: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#representative-form", representative: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/representatives")

      assert html =~ "Representative created successfully"
    end

    test "updates representative in listing", %{conn: conn, representative: representative} do
      {:ok, index_live, _html} = live(conn, ~p"/representatives")

      assert index_live |> element("#representatives-#{representative.id} a", "Edit") |> render_click() =~
               "Edit Representative"

      assert_patch(index_live, ~p"/representatives/#{representative}/edit")

      assert index_live
             |> form("#representative-form", representative: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#representative-form", representative: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/representatives")

      assert html =~ "Representative updated successfully"
    end

    test "deletes representative in listing", %{conn: conn, representative: representative} do
      {:ok, index_live, _html} = live(conn, ~p"/representatives")

      assert index_live |> element("#representatives-#{representative.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#representative-#{representative.id}")
    end
  end

  describe "Show" do
    setup [:create_representative]

    test "displays representative", %{conn: conn, representative: representative} do
      {:ok, _show_live, html} = live(conn, ~p"/representatives/#{representative}")

      assert html =~ "Show Representative"
    end

    test "updates representative within modal", %{conn: conn, representative: representative} do
      {:ok, show_live, _html} = live(conn, ~p"/representatives/#{representative}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Representative"

      assert_patch(show_live, ~p"/representatives/#{representative}/show/edit")

      assert show_live
             |> form("#representative-form", representative: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#representative-form", representative: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/representatives/#{representative}")

      assert html =~ "Representative updated successfully"
    end
  end
end
