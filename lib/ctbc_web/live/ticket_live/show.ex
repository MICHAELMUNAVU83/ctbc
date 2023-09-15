defmodule CtbcWeb.TicketLive.Show do
  use CtbcWeb, :live_view

  alias Ctbc.Tickets
  alias Ctbc.Users

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      Tickets.subscribe()
    else
      IO.inspect("not connected")
    end

    user_signed_in =
      if is_nil(session["user_token"]) do
        false
      else
        true
      end

    current_user =
      if user_signed_in do
        Users.get_user_by_session_token(session["user_token"])
      else
        nil
      end

    {:ok,
     socket
     |> assign(:user_signed_in, user_signed_in)
     |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(%{"ticketid" => ticketid}, _, socket) do
    {:noreply,
     socket
     |> assign(:tickets, Tickets.list_tickets())
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ticket, Tickets.get_ticket_by_ticketid(ticketid))}
  end

  def handle_info({:update_ticket, ticket}, socket) do
    # updated_ticket = Enum.filter(socket.assigns.tickets, fn b -> b.id == ticket.id end)

    updated =
      Enum.map(
        socket.assigns.tickets,
        fn b ->
          if b.id == ticket.id do
            ticket
          else
            b
          end
        end
      )
      |> Enum.filter(fn b -> b.id == socket.assigns.ticket.id end)
      |> Enum.at(0)

    new_updated_ticket = Tickets.get_ticket_by_ticketid(updated.ticketid)

    IO.inspect(new_updated_ticket)

    {:noreply, assign(socket, :ticket, new_updated_ticket)}
  end

  def handle_event("scan", %{"id" => id}, socket) do
    ticket = Tickets.get_ticket!(id)

    body = %{
      "status" => "Scanned"
    }

    {:ok, ticket} = Tickets.update_ticket(ticket, body)

    new_updated_ticket = Tickets.get_ticket_by_ticketid(ticket.ticketid)

    {:noreply,
     socket
     |> assign(:ticket, new_updated_ticket)}
  end

  defp page_title(:show), do: "Show Ticket"
  defp page_title(:edit), do: "Edit Ticket"
end
