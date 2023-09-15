defmodule Ctbc.MpesaTransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ctbc.MpesaTransactions` context.
  """

  @doc """
  Generate a mpesa_transaction.
  """
  def mpesa_transaction_fixture(attrs \\ %{}) do
    {:ok, mpesa_transaction} =
      attrs
      |> Enum.into(%{
        message: "some message",
        status: 42,
        success: true,
        amount: "some amount",
        transaction_code: "some transaction_code",
        transaction_reference: "some transaction_reference"
      })
      |> Ctbc.MpesaTransactions.create_mpesa_transaction()

    mpesa_transaction
  end
end
