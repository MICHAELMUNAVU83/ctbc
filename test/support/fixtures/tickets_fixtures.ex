defmodule Ctbc.TicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ctbc.Tickets` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        status: "some status",
        ticketid: "some ticketid",
        quantity: "some quantity",
        ticket_type: "some ticket_type",
        event_type: "some event_type",
        ticket_holder_name: "some ticket_holder_name",
        ticket_holder_email: "some ticket_holder_email",
        phone_number: "some phone_number",
        ticket_added_type: "some ticket_added_type",
        ticket_added_by: "some ticket_added_by",
        promo_code_name: "some promo_code_name",
        promo_code_number: "some promo_code_number",
        total_cost: 42
      })
      |> Ctbc.Tickets.create_ticket()

    ticket
  end
end
