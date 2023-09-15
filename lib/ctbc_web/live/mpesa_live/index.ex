defmodule CtbcWeb.MpesaLive.Index do
  use CtbcWeb, :live_view

  alias Ctbc.Mpesas
  alias Ctbc.Mpesas.Mpesa

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :mpesas, list_mpesas())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Mpesa")
    |> assign(:mpesa, Mpesas.get_mpesa!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Mpesa")
    |> assign(:mpesa, %Mpesa{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Mpesas")
    |> assign(:mpesa, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    mpesa = Mpesas.get_mpesa!(id)
    {:ok, _} = Mpesas.delete_mpesa(mpesa)

    {:noreply, assign(socket, :mpesas, list_mpesas())}
  end

  defp list_mpesas do
    Mpesas.list_mpesas()
  end
end
