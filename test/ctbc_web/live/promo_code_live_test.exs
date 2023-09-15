defmodule CtbcWeb.PromoCodeLiveTest do
  use CtbcWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ctbc.PromoCodesFixtures

  @create_attrs %{name_of_influencer: "some name_of_influencer", phone_number: "some phone_number", promo_code: "some promo_code"}
  @update_attrs %{name_of_influencer: "some updated name_of_influencer", phone_number: "some updated phone_number", promo_code: "some updated promo_code"}
  @invalid_attrs %{name_of_influencer: nil, phone_number: nil, promo_code: nil}

  defp create_promo_code(_) do
    promo_code = promo_code_fixture()
    %{promo_code: promo_code}
  end

  describe "Index" do
    setup [:create_promo_code]

    test "lists all promo_codes", %{conn: conn, promo_code: promo_code} do
      {:ok, _index_live, html} = live(conn, Routes.promo_code_index_path(conn, :index))

      assert html =~ "Listing Promo codes"
      assert html =~ promo_code.name_of_influencer
    end

    test "saves new promo_code", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.promo_code_index_path(conn, :index))

      assert index_live |> element("a", "New Promo code") |> render_click() =~
               "New Promo code"

      assert_patch(index_live, Routes.promo_code_index_path(conn, :new))

      assert index_live
             |> form("#promo_code-form", promo_code: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#promo_code-form", promo_code: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.promo_code_index_path(conn, :index))

      assert html =~ "Promo code created successfully"
      assert html =~ "some name_of_influencer"
    end

    test "updates promo_code in listing", %{conn: conn, promo_code: promo_code} do
      {:ok, index_live, _html} = live(conn, Routes.promo_code_index_path(conn, :index))

      assert index_live |> element("#promo_code-#{promo_code.id} a", "Edit") |> render_click() =~
               "Edit Promo code"

      assert_patch(index_live, Routes.promo_code_index_path(conn, :edit, promo_code))

      assert index_live
             |> form("#promo_code-form", promo_code: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#promo_code-form", promo_code: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.promo_code_index_path(conn, :index))

      assert html =~ "Promo code updated successfully"
      assert html =~ "some updated name_of_influencer"
    end

    test "deletes promo_code in listing", %{conn: conn, promo_code: promo_code} do
      {:ok, index_live, _html} = live(conn, Routes.promo_code_index_path(conn, :index))

      assert index_live |> element("#promo_code-#{promo_code.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#promo_code-#{promo_code.id}")
    end
  end

  describe "Show" do
    setup [:create_promo_code]

    test "displays promo_code", %{conn: conn, promo_code: promo_code} do
      {:ok, _show_live, html} = live(conn, Routes.promo_code_show_path(conn, :show, promo_code))

      assert html =~ "Show Promo code"
      assert html =~ promo_code.name_of_influencer
    end

    test "updates promo_code within modal", %{conn: conn, promo_code: promo_code} do
      {:ok, show_live, _html} = live(conn, Routes.promo_code_show_path(conn, :show, promo_code))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Promo code"

      assert_patch(show_live, Routes.promo_code_show_path(conn, :edit, promo_code))

      assert show_live
             |> form("#promo_code-form", promo_code: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#promo_code-form", promo_code: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.promo_code_show_path(conn, :show, promo_code))

      assert html =~ "Promo code updated successfully"
      assert html =~ "some updated name_of_influencer"
    end
  end
end
