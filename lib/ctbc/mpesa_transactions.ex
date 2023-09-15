defmodule Ctbc.MpesaTransactions do
  @moduledoc """
  The MpesaTransactions context.
  """

  import Ecto.Query, warn: false
  alias Ctbc.Repo

  alias Ctbc.MpesaTransactions.MpesaTransaction

  @doc """
  Returns the list of mpesa_transactions.

  ## Examples

      iex> list_mpesa_transactions()
      [%MpesaTransaction{}, ...]

  """
  def list_mpesa_transactions do
    Repo.all(MpesaTransaction)
  end

  def paginate_mpesa_transactions(params) do
    Repo.paginate(MpesaTransaction, params)
  end

  def list_transactions_by_search(search) do
    if search == "" do
      query =
        Repo.all(MpesaTransaction)
    else
      query =
        Repo.all(MpesaTransaction)
        |> Enum.filter(fn transaction ->
          String.contains?(
            String.downcase(transaction.transaction_code),
            String.downcase(search)
          ) or
            String.contains?(
              String.downcase(transaction.transaction_reference),
              String.downcase(search)
            )
        end)
    end
  end

  def list_transactions_by_success(status) do
    if status == "" do
      query =
        Repo.all(MpesaTransaction)
    else
      query =
        Repo.all(MpesaTransaction)
        |> Enum.filter(fn transaction ->
          transaction.success == status
        end)
    end
  end

  @doc """
  Gets a single mpesa_transaction.

  Raises `Ecto.NoResultsError` if the Mpesa transaction does not exist.

  ## Examples

      iex> get_mpesa_transaction!(123)
      %MpesaTransaction{}

      iex> get_mpesa_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mpesa_transaction!(id), do: Repo.get!(MpesaTransaction, id)

  @doc """
  Creates a mpesa_transaction.

  ## Examples

      iex> create_mpesa_transaction(%{field: value})
      {:ok, %MpesaTransaction{}}

      iex> create_mpesa_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mpesa_transaction(attrs \\ %{}) do
    %MpesaTransaction{}
    |> MpesaTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mpesa_transaction.

  ## Examples

      iex> update_mpesa_transaction(mpesa_transaction, %{field: new_value})
      {:ok, %MpesaTransaction{}}

      iex> update_mpesa_transaction(mpesa_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mpesa_transaction(%MpesaTransaction{} = mpesa_transaction, attrs) do
    mpesa_transaction
    |> MpesaTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mpesa_transaction.

  ## Examples

      iex> delete_mpesa_transaction(mpesa_transaction)
      {:ok, %MpesaTransaction{}}

      iex> delete_mpesa_transaction(mpesa_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mpesa_transaction(%MpesaTransaction{} = mpesa_transaction) do
    Repo.delete(mpesa_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mpesa_transaction changes.

  ## Examples

      iex> change_mpesa_transaction(mpesa_transaction)
      %Ecto.Changeset{data: %MpesaTransaction{}}

  """
  def change_mpesa_transaction(%MpesaTransaction{} = mpesa_transaction, attrs \\ %{}) do
    MpesaTransaction.changeset(mpesa_transaction, attrs)
  end
end
