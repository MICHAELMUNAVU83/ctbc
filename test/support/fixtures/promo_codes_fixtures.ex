defmodule Ctbc.PromoCodesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ctbc.PromoCodes` context.
  """

  @doc """
  Generate a promo_code.
  """
  def promo_code_fixture(attrs \\ %{}) do
    {:ok, promo_code} =
      attrs
      |> Enum.into(%{
        name_of_influencer: "some name_of_influencer",
        phone_number: "some phone_number",
        promo_code: "some promo_code"
      })
      |> Ctbc.PromoCodes.create_promo_code()

    promo_code
  end
end
