defmodule CtbcWeb.TicketLive.FormComponent do
  use CtbcWeb, :live_component

  alias Ctbc.Tickets
  alias Ctbc.Events

  @impl true
  def update(%{ticket: ticket} = assigns, socket) do
    changeset = Tickets.change_ticket(ticket)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"ticket" => ticket_params}, socket) do
    changeset =
      socket.assigns.ticket
      |> Tickets.change_ticket(ticket_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"ticket" => ticket_params}, socket) do
    save_ticket(socket, socket.assigns.action, ticket_params)
  end

  defp save_ticket(socket, :edit, ticket_params) do
    IO.inspect(ticket_params)
    event = Events.get_event!(ticket_params["event_id"])

    new_ticket_params =
      ticket_params
      |> Map.put(
        "total_cost",
        String.to_integer(event.price) * String.to_integer(ticket_params["quantity"])
      )

    case Tickets.update_ticket(socket.assigns.ticket, new_ticket_params) do
      {:ok, _ticket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ticket updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_ticket(socket, :new, ticket_params) do
    IO.inspect(ticket_params)
    event = Events.get_event!(ticket_params["event_id"])

    get_timestamp =
      Timex.local()
      |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")

    last_element = String.at(get_timestamp, String.length(get_timestamp) - 1)

    uuid =
      SecureRandom.base64(String.to_integer(last_element))
      |> String.replace("=", "t")
      |> String.replace("-", "y")
      |> String.replace("/", "a")
      |> String.upcase()
      |> String.slice(0, 6)

    ticket_id = "TKKE#{get_timestamp}#{uuid}"

    IO.inspect(ticket_id)

    new_ticket_params =
      ticket_params
      |> Map.put("ticketid", ticket_id)
      |> Map.put("event_type", event.type)
      |> Map.put(
        "total_cost",
        String.to_integer(event.price) * String.to_integer(ticket_params["quantity"])
      )

    IO.inspect(new_ticket_params)

    case Tickets.create_ticket(new_ticket_params) do
      {:ok, _ticket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ticket created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
