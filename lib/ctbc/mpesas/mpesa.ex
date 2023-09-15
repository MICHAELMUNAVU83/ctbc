defmodule Ctbc.Mpesas.Mpesa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mpesas" do
    field :no_of_tickets, :string
    field :phone_number, :string
    field :email, :string
    field :deliver_ticket_by, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(mpesa, attrs) do
    mpesa
    |> cast(attrs, [:phone_number, :no_of_tickets, :email, :deliver_ticket_by, :name])
    |> validate_required([:phone_number, :no_of_tickets, :email, :deliver_ticket_by, :name],
      message: "Please fill in this field"
    )
    |> validate_format(
      :phone_number,
      ~r/^254\d{9}$/,
      message: "Number has to start with 254 and have 12 digits"
    )
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
  end
end
