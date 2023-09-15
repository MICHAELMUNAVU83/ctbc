defmodule Ctbc.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :string
      add :date_of_event, :string
      add :time_of_starting, :string
      add :time_of_ending, :string
      add :type, :string
      add :price, :string
      add :venue, :string
      add :image, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
