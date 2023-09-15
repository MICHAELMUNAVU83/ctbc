defmodule CtbcWeb.MpesaTransactionControllerTest do
  use CtbcWeb.ConnCase

  import Ctbc.MpesaTransactionsFixtures

  alias Ctbc.MpesaTransactions.MpesaTransaction

  @create_attrs %{
    message: "some message",
    status: 42,
    success: true,
    amount: "some amount",
    transaction_code: "some transaction_code",
    transaction_reference: "some transaction_reference"
  }
  @update_attrs %{
    message: "some updated message",
    status: 43,
    success: false,
    amount: "some updated amount",
    transaction_code: "some updated transaction_code",
    transaction_reference: "some updated transaction_reference"
  }
  @invalid_attrs %{message: nil, status: nil, success: nil, amount: nil, transaction_code: nil, transaction_reference: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mpesa_transactions", %{conn: conn} do
      conn = get(conn, Routes.mpesa_transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mpesa_transaction" do
    test "renders mpesa_transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.mpesa_transaction_path(conn, :create), mpesa_transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.mpesa_transaction_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "amount" => "some amount",
               "message" => "some message",
               "status" => 42,
               "success" => true,
               "transaction_code" => "some transaction_code",
               "transaction_reference" => "some transaction_reference"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.mpesa_transaction_path(conn, :create), mpesa_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mpesa_transaction" do
    setup [:create_mpesa_transaction]

    test "renders mpesa_transaction when data is valid", %{conn: conn, mpesa_transaction: %MpesaTransaction{id: id} = mpesa_transaction} do
      conn = put(conn, Routes.mpesa_transaction_path(conn, :update, mpesa_transaction), mpesa_transaction: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.mpesa_transaction_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "amount" => "some updated amount",
               "message" => "some updated message",
               "status" => 43,
               "success" => false,
               "transaction_code" => "some updated transaction_code",
               "transaction_reference" => "some updated transaction_reference"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, mpesa_transaction: mpesa_transaction} do
      conn = put(conn, Routes.mpesa_transaction_path(conn, :update, mpesa_transaction), mpesa_transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mpesa_transaction" do
    setup [:create_mpesa_transaction]

    test "deletes chosen mpesa_transaction", %{conn: conn, mpesa_transaction: mpesa_transaction} do
      conn = delete(conn, Routes.mpesa_transaction_path(conn, :delete, mpesa_transaction))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.mpesa_transaction_path(conn, :show, mpesa_transaction))
      end
    end
  end

  defp create_mpesa_transaction(_) do
    mpesa_transaction = mpesa_transaction_fixture()
    %{mpesa_transaction: mpesa_transaction}
  end
end
