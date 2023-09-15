defmodule CtbcWeb.PromoCodeLive.Index do
  use CtbcWeb, :dashboard_live_view

  alias Ctbc.PromoCodes
  alias Ctbc.PromoCodes.PromoCode
  alias Ctbc.Users
  alias Ctbc.Events

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    events =
      Events.list_events()
      |> Enum.filter(fn event -> event.status == "Active" end)
      |> Enum.map(fn event -> {event.name, event.id} end)

    {:ok,
     socket
     |> assign(:promo_codes, list_promo_codes())
     |> assign(:events, events)
     |> assign(:url, "/promo_codes")
     |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Promo code")
    |> assign(:promo_code, PromoCodes.get_promo_code!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Promo code")
    |> assign(:promo_code, %PromoCode{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Promo codes")
    |> assign(:promo_code, nil)
  end

  def handle_event("send_sms", params, socket) do
    promo_code = PromoCodes.get_promo_code!(params["id"])

    url =
      "https://Ctbctest.fly.dev/" <>
        "events" <>
        "/" <>
        Integer.to_string(promo_code.event_id) <>
        "/" <> promo_code.name_of_influencer <> "/" <> promo_code.promo_code

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
        "from" => "TIARACONECT",
        "to" => promo_code.phone_number,
        "message" =>
          "Hello #{promo_code.name_of_influencer} ,Thanks for being an influencer with us , We look forward to working together , share this link to your fans and they will get a 10% discount as you earn . #{url}",
        "refId" => "09wiwu088e"
      }
      |> Poison.encode!()

    HTTPoison.post(sms_url, sms_body, sms_headers)

    {:noreply,
     socket
     |> put_flash(:info, "SMS sent successfully")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    promo_code = PromoCodes.get_promo_code!(id)
    {:ok, _} = PromoCodes.delete_promo_code(promo_code)

    {:noreply, assign(socket, :promo_codes, list_promo_codes())}
  end

  defp list_promo_codes do
    PromoCodes.list_promo_codes()
  end
end
