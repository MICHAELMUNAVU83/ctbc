defmodule Ctbc.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :ticketid, :string
      add :quantity, :string
      add :ticket_type, :string
      add :event_type, :string
      add :status, :string
      add :ticket_holder_name, :string
      add :ticket_holder_email, :string
      add :phone_number, :string
      add :ticket_added_type, :string
      add :ticket_added_by, :string
      add :promo_code_name, :string
      add :promo_code_number, :string
      add :total_cost, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end
  end
end
