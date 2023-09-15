defmodule CtbcWeb.PromoCodeLive.Index do
  use CtbcWeb, :live_view

  alias Ctbc.PromoCodes
  alias Ctbc.PromoCodes.PromoCode

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :promo_codes, list_promo_codes())}
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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    promo_code = PromoCodes.get_promo_code!(id)
    {:ok, _} = PromoCodes.delete_promo_code(promo_code)

    {:noreply, assign(socket, :promo_codes, list_promo_codes())}
  end

  defp list_promo_codes do
    PromoCodes.list_promo_codes()
  end
end
