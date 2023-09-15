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
    |> validate_required([:name_of_influencer, :phone_number, :promo_code, :event_id, :user_id])
  end
end
