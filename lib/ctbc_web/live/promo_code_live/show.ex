defmodule CtbcWeb.PromoCodeLive.Show do
  use CtbcWeb, :live_view

  alias Ctbc.PromoCodes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:promo_code, PromoCodes.get_promo_code!(id))}
  end

  defp page_title(:show), do: "Show Promo code"
  defp page_title(:edit), do: "Edit Promo code"
end
