defmodule Ctbc.MpesasTest do
  use Ctbc.DataCase

  alias Ctbc.Mpesas

  describe "mpesas" do
    alias Ctbc.Mpesas.Mpesa

    import Ctbc.MpesasFixtures

    @invalid_attrs %{name: nil, phone_number: nil, no_of_tickets: nil, email: nil, deliver_ticket_by: nil}

    test "list_mpesas/0 returns all mpesas" do
      mpesa = mpesa_fixture()
      assert Mpesas.list_mpesas() == [mpesa]
    end

    test "get_mpesa!/1 returns the mpesa with given id" do
      mpesa = mpesa_fixture()
      assert Mpesas.get_mpesa!(mpesa.id) == mpesa
    end

    test "create_mpesa/1 with valid data creates a mpesa" do
      valid_attrs = %{name: "some name", phone_number: "some phone_number", no_of_tickets: "some no_of_tickets", email: "some email", deliver_ticket_by: "some deliver_ticket_by"}

      assert {:ok, %Mpesa{} = mpesa} = Mpesas.create_mpesa(valid_attrs)
      assert mpesa.name == "some name"
      assert mpesa.phone_number == "some phone_number"
      assert mpesa.no_of_tickets == "some no_of_tickets"
      assert mpesa.email == "some email"
      assert mpesa.deliver_ticket_by == "some deliver_ticket_by"
    end

    test "create_mpesa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mpesas.create_mpesa(@invalid_attrs)
    end

    test "update_mpesa/2 with valid data updates the mpesa" do
      mpesa = mpesa_fixture()
      update_attrs = %{name: "some updated name", phone_number: "some updated phone_number", no_of_tickets: "some updated no_of_tickets", email: "some updated email", deliver_ticket_by: "some updated deliver_ticket_by"}

      assert {:ok, %Mpesa{} = mpesa} = Mpesas.update_mpesa(mpesa, update_attrs)
      assert mpesa.name == "some updated name"
      assert mpesa.phone_number == "some updated phone_number"
      assert mpesa.no_of_tickets == "some updated no_of_tickets"
      assert mpesa.email == "some updated email"
      assert mpesa.deliver_ticket_by == "some updated deliver_ticket_by"
    end

    test "update_mpesa/2 with invalid data returns error changeset" do
      mpesa = mpesa_fixture()
      assert {:error, %Ecto.Changeset{}} = Mpesas.update_mpesa(mpesa, @invalid_attrs)
      assert mpesa == Mpesas.get_mpesa!(mpesa.id)
    end

    test "delete_mpesa/1 deletes the mpesa" do
      mpesa = mpesa_fixture()
      assert {:ok, %Mpesa{}} = Mpesas.delete_mpesa(mpesa)
      assert_raise Ecto.NoResultsError, fn -> Mpesas.get_mpesa!(mpesa.id) end
    end

    test "change_mpesa/1 returns a mpesa changeset" do
      mpesa = mpesa_fixture()
      assert %Ecto.Changeset{} = Mpesas.change_mpesa(mpesa)
    end
  end
end
