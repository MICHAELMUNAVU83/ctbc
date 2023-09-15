defmodule CtbcWeb.MpesaLiveTest do
  use CtbcWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ctbc.MpesasFixtures

  @create_attrs %{name: "some name", phone_number: "some phone_number", no_of_tickets: "some no_of_tickets", email: "some email", deliver_ticket_by: "some deliver_ticket_by"}
  @update_attrs %{name: "some updated name", phone_number: "some updated phone_number", no_of_tickets: "some updated no_of_tickets", email: "some updated email", deliver_ticket_by: "some updated deliver_ticket_by"}
  @invalid_attrs %{name: nil, phone_number: nil, no_of_tickets: nil, email: nil, deliver_ticket_by: nil}

  defp create_mpesa(_) do
    mpesa = mpesa_fixture()
    %{mpesa: mpesa}
  end

  describe "Index" do
    setup [:create_mpesa]

    test "lists all mpesas", %{conn: conn, mpesa: mpesa} do
      {:ok, _index_live, html} = live(conn, Routes.mpesa_index_path(conn, :index))

      assert html =~ "Listing Mpesas"
      assert html =~ mpesa.name
    end

    test "saves new mpesa", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.mpesa_index_path(conn, :index))

      assert index_live |> element("a", "New Mpesa") |> render_click() =~
               "New Mpesa"

      assert_patch(index_live, Routes.mpesa_index_path(conn, :new))

      assert index_live
             |> form("#mpesa-form", mpesa: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#mpesa-form", mpesa: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.mpesa_index_path(conn, :index))

      assert html =~ "Mpesa created successfully"
      assert html =~ "some name"
    end

    test "updates mpesa in listing", %{conn: conn, mpesa: mpesa} do
      {:ok, index_live, _html} = live(conn, Routes.mpesa_index_path(conn, :index))

      assert index_live |> element("#mpesa-#{mpesa.id} a", "Edit") |> render_click() =~
               "Edit Mpesa"

      assert_patch(index_live, Routes.mpesa_index_path(conn, :edit, mpesa))

      assert index_live
             |> form("#mpesa-form", mpesa: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#mpesa-form", mpesa: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.mpesa_index_path(conn, :index))

      assert html =~ "Mpesa updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes mpesa in listing", %{conn: conn, mpesa: mpesa} do
      {:ok, index_live, _html} = live(conn, Routes.mpesa_index_path(conn, :index))

      assert index_live |> element("#mpesa-#{mpesa.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#mpesa-#{mpesa.id}")
    end
  end

  describe "Show" do
    setup [:create_mpesa]

    test "displays mpesa", %{conn: conn, mpesa: mpesa} do
      {:ok, _show_live, html} = live(conn, Routes.mpesa_show_path(conn, :show, mpesa))

      assert html =~ "Show Mpesa"
      assert html =~ mpesa.name
    end

    test "updates mpesa within modal", %{conn: conn, mpesa: mpesa} do
      {:ok, show_live, _html} = live(conn, Routes.mpesa_show_path(conn, :show, mpesa))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Mpesa"

      assert_patch(show_live, Routes.mpesa_show_path(conn, :edit, mpesa))

      assert show_live
             |> form("#mpesa-form", mpesa: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#mpesa-form", mpesa: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.mpesa_show_path(conn, :show, mpesa))

      assert html =~ "Mpesa updated successfully"
      assert html =~ "some updated name"
    end
  end
end
