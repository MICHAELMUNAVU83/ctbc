defmodule CtbcWeb.DashboardLive.Index do
  use CtbcWeb, :dashboard_live_view
  alias Ctbc.Tickets
  alias Ctbc.PromoCodes

  alias Ctbc.Users

  def mount(params, session, socket) do
    gate_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.ticket_type == "Gate" end)

    online_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.ticket_type == "Online" end)

    promo_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.ticket_added_type == "Promo" end)

    normal_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.ticket_added_type == "Normal" end)

    early_bird_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.event_type == "Early Bird" end)

    advanced_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.event_type == "Advanced" end)

    flash_sale_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.event_type == "Flash Sale" end)

    scanned_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.status == "Scanned" end)

    not_scanned_tickets =
      Tickets.list_tickets()
      |> Enum.filter(fn ticket -> ticket.status == "Not Scanned" end)

    promo_codes = PromoCodes.list_promo_codes()

    all_tickets = Tickets.list_tickets()

    promoters = PromoCodes.list_promo_codes()

    revenue =
      Tickets.list_tickets()
      |> Enum.map(fn ticket -> ticket.total_cost end)
      |> Enum.sum()

    staff =
      Users.list_users()
      |> Enum.filter(fn user -> user.role == "verified" end)

    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:url, "/dashboard")
     |> assign(:gate_tickets, gate_tickets)
     |> assign(:revenue, Tickets.format_number(revenue))
     |> assign(:promoters, promoters)
     |> assign(:current_user, current_user)
     |> assign(:online_tickets, online_tickets)
     |> assign(:all_tickets, all_tickets)
     |> assign(:staff, staff)
     |> assign(:promo_codes, promo_codes)
     |> assign(:promo_tickets, promo_tickets)
     |> assign(:normal_tickets, normal_tickets)
     |> assign(:early_bird_tickets, early_bird_tickets)
     |> assign(:advanced_tickets, advanced_tickets)
     |> assign(:flash_sale_tickets, flash_sale_tickets)
     |> assign(:scanned_tickets, scanned_tickets)
     |> assign(:not_scanned_tickets, not_scanned_tickets)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end
end
