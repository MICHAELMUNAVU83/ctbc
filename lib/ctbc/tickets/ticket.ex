defmodule Ctbc.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :status, :string
    field :ticketid, :string
    field :quantity, :string
    field :ticket_type, :string
    field :event_type, :string
    field :phone_number, :string
    field :ticket_added_type, :string
    field :ticket_added_by, :string
    field :promo_code_name, :string
    field :total_cost, :integer
    field :ticket_holder_name, :string
    field :ticket_holder_email, :string

    field :promo_code_number, :string
    belongs_to :user, Ctbc.Users.User
    belongs_to :event, Ctbc.Events.Event

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [
      :ticketid,
      :quantity,
      :ticket_type,
      :event_type,
      :status,
      :phone_number,
      :user_id,
      :event_id,
      :ticket_added_type,
      :promo_code_name,
      :promo_code_number,
      :total_cost,
      :ticket_holder_name,
      :ticket_holder_email
    ])
    |> validate_required([
      :ticketid,
      :quantity,
      :ticket_type,
      :event_type,
      :status,
      :phone_number,
      :user_id,
      :event_id,
      :ticket_added_type,
      :total_cost,
      :ticket_holder_name,
      :ticket_holder_email
    ])
    |> validate_format(
      :phone_number,
      ~r/^254\d{9}$/,
      message: "Number has to start with 254 and have 12 digits"
    )
  end
end
