defmodule Ctbc.Mpesas.Mpesa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mpesas" do
    field :name, :string
    field :phone_number, :string
    field :no_of_tickets, :string
    field :email, :string
    field :deliver_ticket_by, :string

    timestamps()
  end

  @doc false
  def changeset(mpesa, attrs) do
    mpesa
    |> cast(attrs, [:phone_number, :no_of_tickets, :email, :deliver_ticket_by, :name])
    |> validate_required([:phone_number, :no_of_tickets, :email, :deliver_ticket_by, :name])
  end
end
