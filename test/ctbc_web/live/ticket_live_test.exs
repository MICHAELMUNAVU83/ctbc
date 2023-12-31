defmodule CtbcWeb.TicketLiveTest do
  use CtbcWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ctbc.TicketsFixtures

  @create_attrs %{status: "some status", ticketid: "some ticketid", quantity: "some quantity", ticket_type: "some ticket_type", event_type: "some event_type", ticket_holder_name: "some ticket_holder_name", ticket_holder_email: "some ticket_holder_email", phone_number: "some phone_number", ticket_added_type: "some ticket_added_type", ticket_added_by: "some ticket_added_by", promo_code_name: "some promo_code_name", promo_code_number: "some promo_code_number", total_cost: 42}
  @update_attrs %{status: "some updated status", ticketid: "some updated ticketid", quantity: "some updated quantity", ticket_type: "some updated ticket_type", event_type: "some updated event_type", ticket_holder_name: "some updated ticket_holder_name", ticket_holder_email: "some updated ticket_holder_email", phone_number: "some updated phone_number", ticket_added_type: "some updated ticket_added_type", ticket_added_by: "some updated ticket_added_by", promo_code_name: "some updated promo_code_name", promo_code_number: "some updated promo_code_number", total_cost: 43}
  @invalid_attrs %{status: nil, ticketid: nil, quantity: nil, ticket_type: nil, event_type: nil, ticket_holder_name: nil, ticket_holder_email: nil, phone_number: nil, ticket_added_type: nil, ticket_added_by: nil, promo_code_name: nil, promo_code_number: nil, total_cost: nil}

  defp create_ticket(_) do
    ticket = ticket_fixture()
    %{ticket: ticket}
  end

  describe "Index" do
    setup [:create_ticket]

    test "lists all tickets", %{conn: conn, ticket: ticket} do
      {:ok, _index_live, html} = live(conn, Routes.ticket_index_path(conn, :index))

      assert html =~ "Listing Tickets"
      assert html =~ ticket.status
    end

    test "saves new ticket", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.ticket_index_path(conn, :index))

      assert index_live |> element("a", "New Ticket") |> render_click() =~
               "New Ticket"

      assert_patch(index_live, Routes.ticket_index_path(conn, :new))

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticket-form", ticket: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ticket_index_path(conn, :index))

      assert html =~ "Ticket created successfully"
      assert html =~ "some status"
    end

    test "updates ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, Routes.ticket_index_path(conn, :index))

      assert index_live |> element("#ticket-#{ticket.id} a", "Edit") |> render_click() =~
               "Edit Ticket"

      assert_patch(index_live, Routes.ticket_index_path(conn, :edit, ticket))

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticket-form", ticket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ticket_index_path(conn, :index))

      assert html =~ "Ticket updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, Routes.ticket_index_path(conn, :index))

      assert index_live |> element("#ticket-#{ticket.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ticket-#{ticket.id}")
    end
  end

  describe "Show" do
    setup [:create_ticket]

    test "displays ticket", %{conn: conn, ticket: ticket} do
      {:ok, _show_live, html} = live(conn, Routes.ticket_show_path(conn, :show, ticket))

      assert html =~ "Show Ticket"
      assert html =~ ticket.status
    end

    test "updates ticket within modal", %{conn: conn, ticket: ticket} do
      {:ok, show_live, _html} = live(conn, Routes.ticket_show_path(conn, :show, ticket))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ticket"

      assert_patch(show_live, Routes.ticket_show_path(conn, :edit, ticket))

      assert show_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ticket-form", ticket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.ticket_show_path(conn, :show, ticket))

      assert html =~ "Ticket updated successfully"
      assert html =~ "some updated status"
    end
  end
end
