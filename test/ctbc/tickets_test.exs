defmodule Ctbc.TicketsTest do
  use Ctbc.DataCase

  alias Ctbc.Tickets

  describe "tickets" do
    alias Ctbc.Tickets.Ticket

    import Ctbc.TicketsFixtures

    @invalid_attrs %{status: nil, ticketid: nil, quantity: nil, ticket_type: nil, event_type: nil, ticket_holder_name: nil, ticket_holder_email: nil, phone_number: nil, ticket_added_type: nil, ticket_added_by: nil, promo_code_name: nil, promo_code_number: nil, total_cost: nil}

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Tickets.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Tickets.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      valid_attrs = %{status: "some status", ticketid: "some ticketid", quantity: "some quantity", ticket_type: "some ticket_type", event_type: "some event_type", ticket_holder_name: "some ticket_holder_name", ticket_holder_email: "some ticket_holder_email", phone_number: "some phone_number", ticket_added_type: "some ticket_added_type", ticket_added_by: "some ticket_added_by", promo_code_name: "some promo_code_name", promo_code_number: "some promo_code_number", total_cost: 42}

      assert {:ok, %Ticket{} = ticket} = Tickets.create_ticket(valid_attrs)
      assert ticket.status == "some status"
      assert ticket.ticketid == "some ticketid"
      assert ticket.quantity == "some quantity"
      assert ticket.ticket_type == "some ticket_type"
      assert ticket.event_type == "some event_type"
      assert ticket.ticket_holder_name == "some ticket_holder_name"
      assert ticket.ticket_holder_email == "some ticket_holder_email"
      assert ticket.phone_number == "some phone_number"
      assert ticket.ticket_added_type == "some ticket_added_type"
      assert ticket.ticket_added_by == "some ticket_added_by"
      assert ticket.promo_code_name == "some promo_code_name"
      assert ticket.promo_code_number == "some promo_code_number"
      assert ticket.total_cost == 42
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tickets.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()
      update_attrs = %{status: "some updated status", ticketid: "some updated ticketid", quantity: "some updated quantity", ticket_type: "some updated ticket_type", event_type: "some updated event_type", ticket_holder_name: "some updated ticket_holder_name", ticket_holder_email: "some updated ticket_holder_email", phone_number: "some updated phone_number", ticket_added_type: "some updated ticket_added_type", ticket_added_by: "some updated ticket_added_by", promo_code_name: "some updated promo_code_name", promo_code_number: "some updated promo_code_number", total_cost: 43}

      assert {:ok, %Ticket{} = ticket} = Tickets.update_ticket(ticket, update_attrs)
      assert ticket.status == "some updated status"
      assert ticket.ticketid == "some updated ticketid"
      assert ticket.quantity == "some updated quantity"
      assert ticket.ticket_type == "some updated ticket_type"
      assert ticket.event_type == "some updated event_type"
      assert ticket.ticket_holder_name == "some updated ticket_holder_name"
      assert ticket.ticket_holder_email == "some updated ticket_holder_email"
      assert ticket.phone_number == "some updated phone_number"
      assert ticket.ticket_added_type == "some updated ticket_added_type"
      assert ticket.ticket_added_by == "some updated ticket_added_by"
      assert ticket.promo_code_name == "some updated promo_code_name"
      assert ticket.promo_code_number == "some updated promo_code_number"
      assert ticket.total_cost == 43
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Tickets.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tickets.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Tickets.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Tickets.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Tickets.change_ticket(ticket)
    end
  end
end
