defmodule Ctbc.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :status, :string
    field :type, :string
    field :description, :string
    field :image, :string
    field :date_of_event, :string
    field :time_of_starting, :string
    field :time_of_ending, :string
    field :price, :string
    field :venue, :string
    belongs_to :user, Ctbc.Users.User
    has_many :tickets, Ctbc.Tickets.Ticket
    has_many :promo_codes, Ctbc.PromoCodes.PromoCode

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :description,
      :date_of_event,
      :time_of_starting,
      :time_of_ending,
      :type,
      :price,
      :venue,
      :image,
      :status,
      :user_id
    ])
    |> validate_required([
      :name,
      :description,
      :date_of_event,
      :time_of_starting,
      :time_of_ending,
      :type,
      :price,
      :venue,
      :image,
      :status,
      :user_id
    ])
  end
end
