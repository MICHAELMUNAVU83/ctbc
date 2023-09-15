defmodule Ctbc.Repo.Migrations.CreateMpesaTransactions do
  use Ecto.Migration

  def change do
    create table(:mpesa_transactions) do
      add :message, :string
      add :success, :boolean, default: false, null: false
      add :status, :integer
      add :amount, :string
      add :transaction_code, :string
      add :transaction_reference, :string

      timestamps()
    end
  end
end
