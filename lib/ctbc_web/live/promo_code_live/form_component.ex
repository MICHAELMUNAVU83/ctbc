defmodule CtbcWeb.PromoCodeLive.FormComponent do
  use CtbcWeb, :live_component

  alias Ctbc.PromoCodes

  @impl true
  def update(%{promo_code: promo_code} = assigns, socket) do
    changeset = PromoCodes.change_promo_code(promo_code)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"promo_code" => promo_code_params}, socket) do
    changeset =
      socket.assigns.promo_code
      |> PromoCodes.change_promo_code(promo_code_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"promo_code" => promo_code_params}, socket) do
    save_promo_code(socket, socket.assigns.action, promo_code_params)
  end

  defp save_promo_code(socket, :edit, promo_code_params) do
    case PromoCodes.update_promo_code(socket.assigns.promo_code, promo_code_params) do
      {:ok, _promo_code} ->
        {:noreply,
         socket
         |> put_flash(:info, "Promo code updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_promo_code(socket, :new, promo_code_params) do
    case PromoCodes.create_promo_code(promo_code_params) do
      {:ok, _promo_code} ->
        {:noreply,
         socket
         |> put_flash(:info, "Promo code created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
