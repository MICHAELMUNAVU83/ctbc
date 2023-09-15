defmodule CtbcWeb.TicketLive.Index do
  use CtbcWeb, :dashboard_live_view

  alias Ctbc.Tickets
  alias Ctbc.Tickets.Ticket
  alias Ctbc.Users
  alias Ctbc.Events
  alias Ctbc.Users.UserNotifier

  @impl true
  def mount(params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    events =
      Events.list_events()
      |> Enum.filter(fn event -> event.status == "Active" end)
      |> Enum.map(fn event -> {event.name, event.id} end)

    if connected?(socket) do
      Tickets.subscribe()
    else
      IO.inspect("not connected")
    end

    tickets = Tickets.paginate_tickets(params)

    count =
      Tickets.list_tickets()
      |> length()

    {:ok,
     socket
     |> assign(:tickets, tickets)
     |> assign(:count, count)
     |> assign(:changeset, Tickets.change_ticket(%Ticket{}))
     |> assign(:total_pages, tickets.total_pages)
     |> assign(:page_number, tickets.page_number)
     |> assign(:status_changeset, Tickets.change_ticket(%Ticket{}))
     |> assign(:events, events)
     |> assign(:url, "/tickets")
     |> assign(:current_user, current_user)}
  end

  def handle_info({:new_ticket, ticket}, socket) do
    {:noreply, assign(socket, :tickets, socket.assigns.tickets ++ [ticket])}
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

    {:noreply, assign(socket, :tickets, updated)}
  end

  def handle_info({:delete_ticket, ticket}, socket) do
    updates_tickets = Enum.reject(socket.assigns.tickets, fn b -> b.id == ticket.id end)
    {:noreply, assign(socket, :tickets, updates_tickets)}
  end

  def handle_params(params, _url, socket) do
    tickets = Tickets.paginate_tickets(params)

    {:noreply,
     socket
     |> assign(:tickets, tickets)
     |> assign(:total_pages, tickets.total_pages)
     |> assign(:page_number, tickets.page_number)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ticket")
    |> assign(:ticket, Tickets.get_ticket!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ticket")
    |> assign(:ticket, %Ticket{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tickets")
    |> assign(:ticket, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ticket = Tickets.get_ticket!(id)
    {:ok, _} = Tickets.delete_ticket(ticket)

    {:noreply, assign(socket, :tickets, list_tickets())}
  end

  def handle_event("search", params, socket) do
    count = length(Tickets.list_tickets_by_search(params["ticket"]["search"]))

    {:noreply,
     socket
     |> assign(:count, count)
     |> assign(:tickets, Tickets.list_tickets_by_search(params["ticket"]["search"]))}
  end

  def handle_event("filter_by_status", params, socket) do
    count = length(Tickets.list_tickets_by_status(params["ticket"]["status"]))

    {:noreply,
     socket
     |> assign(:count, count)
     |> assign(:tickets, Tickets.list_tickets_by_status(params["ticket"]["status"]))}
  end

  def handle_event("filter_by_type", params, socket) do
    count = length(Tickets.list_tickets_by_promo(params["ticket"]["type"]))

    IO.inspect(params)

    {:noreply,
     socket
     |> assign(:count, count)
     |> assign(:tickets, Tickets.list_tickets_by_type(params["ticket"]["type"]))}
  end

  def handle_event("send_sms", params, socket) do
    ticket = Tickets.get_ticket!(params["id"])

    url =
      "https://Ctbctest.fly.dev/" <>
        "tickets" <>
        "/" <>
        Integer.to_string(ticket.id)

    IO.inspect(url)

    sms_url = "https://api.tiaraconnect.io/api/messaging/sendsms"

    sms_headers = [
      {
        "Content-Type",
        "application/json"
      },
      {
        "Authorization",
        "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyOTAiLCJvaWQiOjI5MCwidWlkIjoiYWUzMGRjZTItMjIzYi00ODUzLWJmMDItNDE5ZWI2MzMzY2Y5IiwiYXBpZCI6MTgzLCJpYXQiOjE2OTM1OTAzNDksImV4cCI6MjAzMzU5MDM0OX0.mG9d0tTkmx49OQKMKQFYKnIQMHFQEIckHBnGe5jTjg3fU95aHLxrtouqsPGr7Yi3GKFt674_ImiLtJavAa4OIw"
      }
    ]

    sms_body =
      %{
        "from" => "DUCO-ENT",
        "to" => ticket.phone_number,
        "message" =>
          "Hello #{ticket.ticket_holder_name} ,Thanks for purchasing your ticket for The Kulture KE , Dancehall Vs Gengetone . We look forward to seeing you , download your ticket at #{url}",
        "refId" => "09wiwu088e"
      }
      |> Poison.encode!()

    IO.inspect(HTTPoison.post(sms_url, sms_body, sms_headers))

    {:noreply,
     socket
     |> put_flash(:info, "SMS sent successfully")}
  end

  def handle_event("send_email", params, socket) do
    ticket = Tickets.get_ticket!(params["id"])

    url =
      "https://Ctbctest.fly.dev/" <>
        "tickets" <>
        "/" <>
        Integer.to_string(ticket.id)

    UserNotifier.deliver(
      ticket.ticket_holder_email,
      "The Kulture KE Ticket",
      "Hello #{ticket.ticket_holder_email} ,Thanks for purchasing your ticket for The Kulture KE , Dancehall Vs Gengetone . We look forward to seeing you , download your ticket at #{url}"
    )

    {:noreply,
     socket
     |> put_flash(:info, "Email sent successfully")}
  end

  def handle_event("filter_by_promo", params, socket) do
    count = length(Tickets.list_tickets_by_promo(params["ticket"]["promo"]))

    IO.inspect(params)

    {:noreply,
     socket
     |> assign(:count, count)
     |> assign(:tickets, Tickets.list_tickets_by_promo(params["ticket"]["promo"]))}
  end

  defp list_tickets do
    Tickets.list_tickets()
  end
end
