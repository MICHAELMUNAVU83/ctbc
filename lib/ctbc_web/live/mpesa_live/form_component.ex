defmodule CtbcWeb.MpesaLive.FormComponent do
  use CtbcWeb, :live_component

  alias Ctbc.Mpesas

  @impl true
  def update(%{mpesa: mpesa} = assigns, socket) do
    changeset = Mpesas.change_mpesa(mpesa)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"mpesa" => mpesa_params}, socket) do
    changeset =
      socket.assigns.mpesa
      |> Mpesas.change_mpesa(mpesa_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"mpesa" => mpesa_params}, socket) do
    save_mpesa(socket, socket.assigns.action, mpesa_params)
  end

  defp save_mpesa(socket, :edit, mpesa_params) do
    case Mpesas.update_mpesa(socket.assigns.mpesa, mpesa_params) do
      {:ok, _mpesa} ->
        {:noreply,
         socket
         |> put_flash(:info, "Mpesa updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_mpesa(socket, :new, mpesa_params) do
    case Mpesas.create_mpesa(mpesa_params) do
      {:ok, _mpesa} ->
        {:noreply,
         socket
         |> put_flash(:info, "Mpesa created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
