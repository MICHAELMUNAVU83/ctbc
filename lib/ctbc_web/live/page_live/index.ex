defmodule CtbcWeb.PageLive.Index do
  use CtbcWeb, :live_view
  alias Ctbc.Events

  def mount(params, session, socket) do
    events =
      Events.list_events()
      |> Enum.filter(fn event -> event.status == "Scanned" end)

    slides = [
      "/images/slider1.jpg",
      "/images/slider2.jpg",
      "/images/slider3.jpeg",
      "/images/slider4.jpg",
      "/images/slider5.jpg"
    ]

    user_signed_in =
      if is_nil(session["user_token"]) do
        false
      else
        true
      end

    {:ok,
     socket
     |> assign(:events, events)
     |> assign(:user_signed_in, user_signed_in)
     |> assign(:slides, slides)
     |> assign(:page_title, "Home")}
  end
end
