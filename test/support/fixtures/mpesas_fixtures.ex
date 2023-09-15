defmodule Ctbc.MpesasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ctbc.Mpesas` context.
  """

  @doc """
  Generate a mpesa.
  """
  def mpesa_fixture(attrs \\ %{}) do
    {:ok, mpesa} =
      attrs
      |> Enum.into(%{
        name: "some name",
        phone_number: "some phone_number",
        no_of_tickets: "some no_of_tickets",
        email: "some email",
        deliver_ticket_by: "some deliver_ticket_by"
      })
      |> Ctbc.Mpesas.create_mpesa()

    mpesa
  end
end
