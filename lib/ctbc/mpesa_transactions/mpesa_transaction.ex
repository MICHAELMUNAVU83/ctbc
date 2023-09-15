defmodule Ctbc.MpesaTransactions.MpesaTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mpesa_transactions" do
    field :message, :string
    field :status, :integer
    field :success, :boolean, default: false
    field :amount, :string
    field :transaction_code, :string
    field :transaction_reference, :string

    timestamps()
  end

  @doc false
  def changeset(mpesa_transaction, attrs) do
    mpesa_transaction
    |> cast(attrs, [:message, :success, :status, :amount, :transaction_code, :transaction_reference])
    |> validate_required([:message, :success, :status, :amount, :transaction_code, :transaction_reference])
  end
end
