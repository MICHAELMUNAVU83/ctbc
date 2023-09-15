defmodule Ctbc.PromoCodes.PromoCode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "promo_codes" do
    field :name_of_influencer, :string
    field :phone_number, :string
    field :promo_code, :string
    belongs_to :event, Ctbc.Events.Event
    belongs_to :user, Ctbc.Users.User

    timestamps()
  end

  @doc false
  def changeset(promo_code, attrs) do
    promo_code
    |> cast(attrs, [:name_of_influencer, :phone_number, :promo_code, :event_id, :user_id])
    |> validate_format(
      :phone_number,
      ~r/^254\d{9}$/,
      message: "Number has to start with 254 and have 12 digits"
    )
    |> validate_required([:name_of_influencer, :phone_number, :promo_code, :event_id, :user_id])
    |> validate_format(:name_of_influencer, ~r/\A[^ ]*\z/, message: "must not contain spaces")
    |> unique_constraint(:promo_code, message: "Promo code already exists")
    |> unique_constraint(:phone_number, message: "Phone number already exists")
    |> unique_constraint(:name_of_influencer, message: "Name of influencer already exists")
  end
end
