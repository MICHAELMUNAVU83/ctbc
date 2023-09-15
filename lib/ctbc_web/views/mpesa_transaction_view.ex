defmodule CtbcWeb.MpesaTransactionView do
  use CtbcWeb, :view
  alias CtbcWeb.MpesaTransactionView

  def render("index.json", %{mpesa_transactions: mpesa_transactions}) do
    %{data: render_many(mpesa_transactions, MpesaTransactionView, "mpesa_transaction.json")}
  end

  def render("show.json", %{mpesa_transaction: mpesa_transaction}) do
    %{data: render_one(mpesa_transaction, MpesaTransactionView, "mpesa_transaction.json")}
  end

  def render("mpesa_transaction.json", %{mpesa_transaction: mpesa_transaction}) do
    %{
      id: mpesa_transaction.id,
      message: mpesa_transaction.message,
      success: mpesa_transaction.success,
      status: mpesa_transaction.status,
      amount: mpesa_transaction.amount,
      transaction_code: mpesa_transaction.transaction_code,
      transaction_reference: mpesa_transaction.transaction_reference
    }
  end
end
