defmodule CtbcWeb.EventLive.PromoCode do
  use CtbcWeb, :live_view

  alias Ctbc.Events
  alias Ctbc.Events.Event
  alias Ctbc.Users
  alias Ctbc.Mpesas
  alias Ctbc.Mpesas.Mpesa
  alias Ctbc.Tickets
  alias Ctbc.Users.UserNotifier

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    user_signed_in =
      if is_nil(session["user_token"]) do
        false
      else
        true
      end

    {:ok,
     socket
     |> assign(:user_signed_in, user_signed_in)
     |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(
        %{
          "id" => id,
          "promo_code_number" => promo_code_number,
          "promo_code_name" => promo_code_name
        },
        _,
        socket
      ) do
    changeset = Mpesas.change_mpesa(%Mpesa{})

    promo_codes_for_this_event = Events.list_event_promo_codes(String.to_integer(id)).promo_codes

    IO.inspect(promo_codes_for_this_event)

    correct_promo_code =
      Enum.any?(promo_codes_for_this_event, fn x ->
        x.promo_code == promo_code_number && x.name_of_influencer == promo_code_name
      end)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:changeset, changeset)
     |> assign(:checkoutId, "")
     |> assign(:mpesa_number, "")
     |> assign(:url, "/tickets")
     |> assign(:number_of_tickets, "")
     |> assign(:success_modal, false)
     |> assign(:ticket_link, "")
     |> assign(:correct_promo_code, correct_promo_code)
     |> assign(:promo_code_number, promo_code_number)
     |> assign(:promo_code_name, promo_code_name)
     |> assign(:mpesa, %Mpesa{})
     |> assign(:error_modal, false)
     |> assign(:calls_for_user, 0)
     |> assign(:new_number_of_calls, 0)
     |> assign(:payment_state, "initiated")
     |> assign(:ticket_number, "")
     |> assign(:error_message, "")
     |> assign(:total_cost, "")
     |> assign(:event, Events.get_event!(id))}
  end

  def handle_event("validate", %{"mpesa" => mpesa_params}, socket) do
    changeset =
      socket.assigns.mpesa
      |> Mpesas.change_mpesa(mpesa_params)
      |> Map.put(:action, :validate)

    total_cost =
      if mpesa_params["no_of_tickets"] != "" do
        String.to_integer(mpesa_params["no_of_tickets"]) *
          (String.to_integer(socket.assigns.event.price) * 0.9)
      else
        ""
      end

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:number_of_tickets, mpesa_params["no_of_tickets"])
     |> assign(:total_cost, total_cost)}
  end

  def handle_event(
        "pay",
        %{
          "mpesa" => %{
            "no_of_tickets" => no_of_tickets,
            "phone_number" => phone_number,
            "email" => email,
            "deliver_ticket_by" => deliver_ticket_by,
            "name" => name
          }
        },
        socket
      ) do
    mpesa_params = %{
      "no_of_tickets" => no_of_tickets,
      "phone_number" => phone_number,
      "email" => email,
      "deliver_ticket_by" => deliver_ticket_by,
      "name" => name
    }

    total_cost = String.to_integer(no_of_tickets) * String.to_integer(socket.assigns.event.price)

    case Mpesas.create_mpesa(mpesa_params) do
      {:ok, _mpesa} ->
        url = "https://api.chpter.co/v1/initiate/mpesa-payment"

        socket = assign(socket, :submitting_payment, true)

        body = %{
          customer_details: %{
            "full_name" => name,
            "location" => "hey",
            "phone_number" => phone_number,
            "email" => email
          },
          products: [
            %{
              "product_name" => "The Kulture Ke Ticket",
              "quantity" => String.to_integer(no_of_tickets),
              "unit_price" => String.to_integer(socket.assigns.event.price),
              "digital_link" => "https://example.com/link"
            }
          ],
          amount: %{
            "currency" => "KES",
            "delivery_fee" => 0.0,
            "discount_fee" => 0.0,
            "total" => 1
          },
          callback_details: %{
            "transaction_reference" => phone_number,
            "callback_url" => "https://Ctbctest.fly.dev/api/mpesa_transactions"
          }
        }

        headers = [
          {
            "Content-Type",
            "application/json"
          },
          {
            "Api-Key",
            "pk_4aff02227456f6b499820c2621ae181c9e35666d25865575fef47622265dcbb9"
          }
        ]

        request_body = Poison.encode!(body)

        body = HTTPoison.get!("https://Ctbctest.fly.dev/api/mpesa_transactions")

        array_of_body =
          Poison.decode!(body.body)["data"]
          |> Enum.filter(fn x ->
            x["transaction_reference"] ==
              phone_number
          end)

        length_of_array = length(array_of_body)

        case IO.inspect(HTTPoison.post(url, request_body, headers)) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            {:noreply,
             socket
             |> assign(:page_title, "Payment")
             |> assign(:payment_state, "confirmation_pending")
             |> assign(:calls_for_user, length_of_array)
             |> assign(:mpesa_number, phone_number)
             |> assign(:number_of_tickets, no_of_tickets)
             |> assign(:deliver_type_selected, deliver_ticket_by)
             |> assign(:recepient_email, email)
             |> assign(:recepient_name, name)
             |> assign(:total_cost, total_cost)
             |> assign(:ticket_number, no_of_tickets)
             |> assign(:new_number_of_calls, length_of_array)
             |> put_flash(:info, "Prompt Sent")}

          {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
            {:noreply, put_flash(socket, :error, "Payment Failed")}

          _ ->
            {:noreply, put_flash(socket, :error, "Payment Failed")}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("check", params, socket) do
    {:noreply,
     socket
     |> check_multiple_times(socket.assigns.calls_for_user, socket.assigns.new_number_of_calls)}
  end

  def check_multiple_times(socket, previous_number_of_calls, new_number_of_calls)
      when previous_number_of_calls == new_number_of_calls do
    IO.puts("still searching for payment")

    body = HTTPoison.get!("https://Ctbctest.fly.dev/api/mpesa_transactions")

    array_of_body =
      Poison.decode!(body.body)["data"]
      |> Enum.filter(fn x -> x["transaction_reference"] == socket.assigns.mpesa_number end)

    length_of_array = length(array_of_body)

    check_multiple_times(socket, previous_number_of_calls, length_of_array)
  end

  def check_multiple_times(socket, previous_number_of_calls, new_number_of_calls)
      when previous_number_of_calls != new_number_of_calls do
    IO.puts("found payment")

    body = HTTPoison.get!("https://Ctbctest.fly.dev/api/mpesa_transactions")

    most_recent_record =
      Poison.decode!(body.body)["data"]
      |> Enum.filter(fn x -> x["transaction_reference"] == socket.assigns.mpesa_number end)
      |> Enum.reverse()
      |> Enum.at(0)

    if most_recent_record["success"] == true do
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

      ticket_params = %{
        "status" => "Not Scanned",
        "ticketid" => ticket_id,
        "event_id" => socket.assigns.event.id,
        "ticket_type" => "Online",
        "event_type" => socket.assigns.event.type,
        "phone_number" => socket.assigns.mpesa_number,
        "quantity" => socket.assigns.number_of_tickets,
        "user_id" => "1",
        "ticket_added_type" => "Promo",
        "promo_code_name" => socket.assigns.promo_code_name,
        "promo_code_number" => socket.assigns.promo_code_number,
        "total_cost" => socket.assigns.total_cost,
        "ticket_holder_name" => socket.assigns.recepient_name,
        "ticket_holder_email" => socket.assigns.recepient_email
      }

      {:ok, _ticket} = Tickets.create_ticket(ticket_params)

      full_ticket_link = "https://Ctbctest.fly.dev/tickets/#{ticket_id}"

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
          "to" => socket.assigns.mpesa_number,
          "message" =>
            "Hello #{socket.assigns.recepient_name} ,Thanks for purchasing your ticket for The Kulture KE , Dancehall Vs Gengetone . We look forward to seeing you , download your ticket at #{full_ticket_link}",
          "refId" => "09wiwu088e"
        }
        |> Poison.encode!()

      if socket.assigns.deliver_type_selected == "SMS" do
        HTTPoison.post(sms_url, sms_body, sms_headers)
      else
        UserNotifier.deliver(
          socket.assigns.recepient_email,
          "The Kulture KE Ticket",
          "Hello #{socket.assigns.recepient_name} ,Thanks for purchasing your ticket for The Kulture KE , Dancehall Vs Gengetone . We look forward to seeing you , download your ticket at #{full_ticket_link}"
        )
      end

      socket
      |> assign(:ticket_link, "/tickets/" <> ticket_id)
      |> assign(:success_modal, true)
    else
      socket
      |> assign(:error_modal, true)
      |> assign(:error_message, most_recent_record["message"])
      |> assign(:payment_state, "initiated")
      |> put_flash(:info, "Payment Failed , #{most_recent_record["Message"]}")
    end
  end

  def handle_event("close_success_modal", %{}, socket) do
    {:noreply,
     socket
     |> assign(:success_modal, false)}
  end

  def handle_event("close_error_modal", %{}, socket) do
    {:noreply,
     socket
     |> assign(:error_modal, false)}
  end

  defp page_title(:index) do
    "Events"
  end

  defp page_title(:buyticketpromocode) do
    "Events"
  end
end
