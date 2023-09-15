defmodule CtbcWeb.MpesaTransactionController do
  use CtbcWeb, :controller

  alias Ctbc.MpesaTransactions
  alias Ctbc.MpesaTransactions.MpesaTransaction

  action_fallback CtbcWeb.FallbackController

  def index(conn, _params) do
    mpesa_transactions = MpesaTransactions.list_mpesa_transactions()
    render(conn, "index.json", mpesa_transactions: mpesa_transactions)
  end

  def create(conn, mpesa_transaction_params) do
    IO.inspect(mpesa_transaction_params)

    new_mpesa_transaction_params = %{
      "message" => mpesa_transaction_params["Message"],
      "success" => mpesa_transaction_params["Success"],
      "status" => mpesa_transaction_params["Status"],
      "amount" => mpesa_transaction_params["Amount"],
      "transaction_code" => mpesa_transaction_params["transaction_code"],
      "transaction_reference" => mpesa_transaction_params["transaction_reference"]
    }

    with {:ok, %MpesaTransaction{} = mpesa_transaction} <-
           IO.inspect(MpesaTransactions.create_mpesa_transaction(new_mpesa_transaction_params)) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.mpesa_transaction_path(conn, :show, mpesa_transaction)
      )
      |> render("show.json", mpesa_transaction: mpesa_transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    mpesa_transaction = MpesaTransactions.get_mpesa_transaction!(id)
    render(conn, "show.json", mpesa_transaction: mpesa_transaction)
  end

  def update(conn, %{"id" => id, "mpesa_transaction" => mpesa_transaction_params}) do
    mpesa_transaction = MpesaTransactions.get_mpesa_transaction!(id)

    with {:ok, %MpesaTransaction{} = mpesa_transaction} <-
           MpesaTransactions.update_mpesa_transaction(mpesa_transaction, mpesa_transaction_params) do
      render(conn, "show.json", mpesa_transaction: mpesa_transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    mpesa_transaction = MpesaTransactions.get_mpesa_transaction!(id)

    with {:ok, %MpesaTransaction{}} <-
           MpesaTransactions.delete_mpesa_transaction(mpesa_transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
