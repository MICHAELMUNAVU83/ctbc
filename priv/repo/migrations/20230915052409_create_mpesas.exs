defmodule Ctbc.Repo.Migrations.CreateMpesas do
  use Ecto.Migration

  def change do
    create table(:mpesas) do
      add :phone_number, :string
      add :no_of_tickets, :string
      add :email, :string
      add :deliver_ticket_by, :string
      add :name, :string

      timestamps()
    end
  end
end
