defmodule CtbcWeb.PaymentLive.Index do
  use CtbcWeb, :dashboard_live_view
  alias Ctbc.MpesaTransactions
  alias Ctbc.MpesaTransactions.MpesaTransaction
  alias Ctbc.Users

  def mount(params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    mpesa_transactions = MpesaTransactions.paginate_mpesa_transactions(params)

    count =
      MpesaTransactions.list_mpesa_transactions()
      |> length()

    {:ok,
     socket
     |> assign(:mpesa_transactions, mpesa_transactions)
     |> assign(:count, count)
     |> assign(:changeset, MpesaTransactions.change_mpesa_transaction(%MpesaTransaction{}))
     |> assign(:total_pages, mpesa_transactions.total_pages)
     |> assign(:page_number, mpesa_transactions.page_number)
     |> assign(:url, "/payments")
     |> assign(:current_user, current_user)}
  end

  def handle_params(params, _url, socket) do
    mpesa_transactions = MpesaTransactions.paginate_mpesa_transactions(params)

    {:noreply,
     socket
     |> assign(:mpesa_transactions, mpesa_transactions)
     |> assign(:total_pages, mpesa_transactions.total_pages)
     |> assign(:page_number, mpesa_transactions.page_number)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Payments")
  end

  def handle_event("search", params, socket) do
    count =
      length(MpesaTransactions.list_transactions_by_search(params["mpesa_transaction"]["search"]))

    IO.inspect(
      MpesaTransactions.list_transactions_by_search(params["mpesa_transaction"]["search"])
    )

    IO.inspect(params["mpesa_transaction"]["search"])

    {:noreply,
     socket
     |> assign(
       :mpesa_transactions,
       MpesaTransactions.list_transactions_by_search(params["mpesa_transaction"]["search"])
     )
     |> assign(:count, count)}
  end

  def handle_event("filter_by_success", params, socket) do
    state =
      if params["mpesa_transaction"]["success"] == "true" do
        true
      else
        false
      end

    count = length(MpesaTransactions.list_transactions_by_success(state))

    IO.inspect(params)

    {:noreply,
     socket
     |> assign(:count, count)
     |> assign(:mpesa_transactions, MpesaTransactions.list_transactions_by_success(state))}
  end
end
