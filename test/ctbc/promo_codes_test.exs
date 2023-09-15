defmodule Ctbc.PromoCodesTest do
  use Ctbc.DataCase

  alias Ctbc.PromoCodes

  describe "promo_codes" do
    alias Ctbc.PromoCodes.PromoCode

    import Ctbc.PromoCodesFixtures

    @invalid_attrs %{name_of_influencer: nil, phone_number: nil, promo_code: nil}

    test "list_promo_codes/0 returns all promo_codes" do
      promo_code = promo_code_fixture()
      assert PromoCodes.list_promo_codes() == [promo_code]
    end

    test "get_promo_code!/1 returns the promo_code with given id" do
      promo_code = promo_code_fixture()
      assert PromoCodes.get_promo_code!(promo_code.id) == promo_code
    end

    test "create_promo_code/1 with valid data creates a promo_code" do
      valid_attrs = %{name_of_influencer: "some name_of_influencer", phone_number: "some phone_number", promo_code: "some promo_code"}

      assert {:ok, %PromoCode{} = promo_code} = PromoCodes.create_promo_code(valid_attrs)
      assert promo_code.name_of_influencer == "some name_of_influencer"
      assert promo_code.phone_number == "some phone_number"
      assert promo_code.promo_code == "some promo_code"
    end

    test "create_promo_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PromoCodes.create_promo_code(@invalid_attrs)
    end

    test "update_promo_code/2 with valid data updates the promo_code" do
      promo_code = promo_code_fixture()
      update_attrs = %{name_of_influencer: "some updated name_of_influencer", phone_number: "some updated phone_number", promo_code: "some updated promo_code"}

      assert {:ok, %PromoCode{} = promo_code} = PromoCodes.update_promo_code(promo_code, update_attrs)
      assert promo_code.name_of_influencer == "some updated name_of_influencer"
      assert promo_code.phone_number == "some updated phone_number"
      assert promo_code.promo_code == "some updated promo_code"
    end

    test "update_promo_code/2 with invalid data returns error changeset" do
      promo_code = promo_code_fixture()
      assert {:error, %Ecto.Changeset{}} = PromoCodes.update_promo_code(promo_code, @invalid_attrs)
      assert promo_code == PromoCodes.get_promo_code!(promo_code.id)
    end

    test "delete_promo_code/1 deletes the promo_code" do
      promo_code = promo_code_fixture()
      assert {:ok, %PromoCode{}} = PromoCodes.delete_promo_code(promo_code)
      assert_raise Ecto.NoResultsError, fn -> PromoCodes.get_promo_code!(promo_code.id) end
    end

    test "change_promo_code/1 returns a promo_code changeset" do
      promo_code = promo_code_fixture()
      assert %Ecto.Changeset{} = PromoCodes.change_promo_code(promo_code)
    end
  end
end
