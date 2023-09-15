defmodule Ctbc.MpesaTransactionsTest do
  use Ctbc.DataCase

  alias Ctbc.MpesaTransactions

  describe "mpesa_transactions" do
    alias Ctbc.MpesaTransactions.MpesaTransaction

    import Ctbc.MpesaTransactionsFixtures

    @invalid_attrs %{message: nil, status: nil, success: nil, amount: nil, transaction_code: nil, transaction_reference: nil}

    test "list_mpesa_transactions/0 returns all mpesa_transactions" do
      mpesa_transaction = mpesa_transaction_fixture()
      assert MpesaTransactions.list_mpesa_transactions() == [mpesa_transaction]
    end

    test "get_mpesa_transaction!/1 returns the mpesa_transaction with given id" do
      mpesa_transaction = mpesa_transaction_fixture()
      assert MpesaTransactions.get_mpesa_transaction!(mpesa_transaction.id) == mpesa_transaction
    end

    test "create_mpesa_transaction/1 with valid data creates a mpesa_transaction" do
      valid_attrs = %{message: "some message", status: 42, success: true, amount: "some amount", transaction_code: "some transaction_code", transaction_reference: "some transaction_reference"}

      assert {:ok, %MpesaTransaction{} = mpesa_transaction} = MpesaTransactions.create_mpesa_transaction(valid_attrs)
      assert mpesa_transaction.message == "some message"
      assert mpesa_transaction.status == 42
      assert mpesa_transaction.success == true
      assert mpesa_transaction.amount == "some amount"
      assert mpesa_transaction.transaction_code == "some transaction_code"
      assert mpesa_transaction.transaction_reference == "some transaction_reference"
    end

    test "create_mpesa_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MpesaTransactions.create_mpesa_transaction(@invalid_attrs)
    end

    test "update_mpesa_transaction/2 with valid data updates the mpesa_transaction" do
      mpesa_transaction = mpesa_transaction_fixture()
      update_attrs = %{message: "some updated message", status: 43, success: false, amount: "some updated amount", transaction_code: "some updated transaction_code", transaction_reference: "some updated transaction_reference"}

      assert {:ok, %MpesaTransaction{} = mpesa_transaction} = MpesaTransactions.update_mpesa_transaction(mpesa_transaction, update_attrs)
      assert mpesa_transaction.message == "some updated message"
      assert mpesa_transaction.status == 43
      assert mpesa_transaction.success == false
      assert mpesa_transaction.amount == "some updated amount"
      assert mpesa_transaction.transaction_code == "some updated transaction_code"
      assert mpesa_transaction.transaction_reference == "some updated transaction_reference"
    end

    test "update_mpesa_transaction/2 with invalid data returns error changeset" do
      mpesa_transaction = mpesa_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = MpesaTransactions.update_mpesa_transaction(mpesa_transaction, @invalid_attrs)
      assert mpesa_transaction == MpesaTransactions.get_mpesa_transaction!(mpesa_transaction.id)
    end

    test "delete_mpesa_transaction/1 deletes the mpesa_transaction" do
      mpesa_transaction = mpesa_transaction_fixture()
      assert {:ok, %MpesaTransaction{}} = MpesaTransactions.delete_mpesa_transaction(mpesa_transaction)
      assert_raise Ecto.NoResultsError, fn -> MpesaTransactions.get_mpesa_transaction!(mpesa_transaction.id) end
    end

    test "change_mpesa_transaction/1 returns a mpesa_transaction changeset" do
      mpesa_transaction = mpesa_transaction_fixture()
      assert %Ecto.Changeset{} = MpesaTransactions.change_mpesa_transaction(mpesa_transaction)
    end
  end
end
