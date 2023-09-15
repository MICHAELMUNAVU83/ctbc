defmodule Ctbc.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias Ctbc.Repo

  alias Ctbc.Tickets.Ticket

  @doc """
  Returns the list of tickets.

  ## Examples

      iex> list_tickets()
      [%Ticket{}, ...]

  """
  def list_tickets do
    Repo.all(Ticket)
    |> Repo.preload(:event)
  end

  def format_number(number) do
    Integer.to_string(number)
    |> String.split_at(-3)
    |> case do
      {int_part, ""} -> int_part
      {int_part, rest} -> int_part <> "," <> rest
    end
  end

  def paginate_tickets(params) do
    Repo.paginate(Ticket, params)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Ctbc.PubSub, "tickets")
  end

  def broadcast({:ok, ticket}, event) do
    Phoenix.PubSub.broadcast(Ctbc.PubSub, "tickets", {event, ticket})
    {:ok, ticket}
  end

  def broadcast({:error, changeset}, event) do
    {:error, changeset}
  end

  def list_tickets_by_search(search) do
    if search == "" do
      query =
        Repo.all(Ticket)
        |> Repo.preload(:event)
    else
      query =
        Repo.all(Ticket)
        |> Enum.filter(fn ticket ->
          String.contains?(String.downcase(ticket.ticketid), String.downcase(search)) or
            String.contains?(String.downcase(ticket.phone_number), String.downcase(search)) or
            String.contains?(String.downcase(ticket.ticket_holder_name), String.downcase(search)) or
            String.contains?(String.downcase(ticket.ticket_holder_email), String.downcase(search))
        end)
        |> Repo.preload(:event)
    end
  end

  def list_tickets_by_status(status) do
    if status == "" do
      query =
        Repo.all(Ticket)
        |> Repo.preload(:event)
    else
      query =
        Repo.all(Ticket)
        |> Enum.filter(fn ticket ->
          ticket.status == status
        end)
        |> Repo.preload(:event)
    end
  end

  def list_tickets_by_promo(promo) do
    if promo == "" do
      query =
        Repo.all(Ticket)
        |> Repo.preload(:event)
    else
      query =
        Repo.all(Ticket)
        |> Repo.preload(:event)
        |> Enum.filter(fn ticket ->
          ticket.ticket_added_type == promo
        end)
    end
  end

  def list_tickets_sold_by_influencer(name, code) do
    Repo.all(Ticket)
    |> Repo.preload(:event)
    |> Enum.filter(fn ticket ->
      ticket.promo_code_name == name and ticket.promo_code_number == code
    end)
  end

  def list_tickets_by_type(type) do
    if type == "" do
      query =
        Repo.all(Ticket)
        |> Repo.preload(:event)
    else
      query =
        Repo.all(Ticket)
        |> Repo.preload(:event)
        |> Enum.filter(fn ticket ->
          ticket.ticket_type == type
        end)
    end
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id), do: Repo.get!(Ticket, id)

  def get_ticket_by_ticketid(ticketid) do
    Repo.one(from t in Ticket, where: t.ticketid == ^ticketid)
    |> Repo.preload(:event)
  end

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs \\ %{}) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:new_ticket)
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update_ticket)
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
    |> broadcast(:delete_ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end
end
