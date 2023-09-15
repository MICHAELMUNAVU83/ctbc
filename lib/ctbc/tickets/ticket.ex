defmodule Ctbc.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :status, :string
    field :ticketid, :string
    field :quantity, :string
    field :ticket_type, :string
    field :event_type, :string
    field :ticket_holder_name, :string
    field :ticket_holder_email, :string
    field :phone_number, :string
    field :ticket_added_type, :string
    field :ticket_added_by, :string
    field :promo_code_name, :string
    field :promo_code_number, :string
    field :total_cost, :integer
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
      :ticket_holder_name,
      :ticket_holder_email,
      :phone_number,
      :ticket_added_type,
      :ticket_added_by,
      :promo_code_name,
      :promo_code_number,
      :total_cost,
      :user_id,
      :event_id
    ])
    |> validate_required([
      :ticketid,
      :quantity,
      :ticket_type,
      :event_type,
      :status,
      :ticket_holder_name,
      :ticket_holder_email,
      :phone_number,
      :ticket_added_type,
      :ticket_added_by,
      :promo_code_name,
      :promo_code_number,
      :total_cost,
      :user_id,
      :event_id
    ])
  end
end
