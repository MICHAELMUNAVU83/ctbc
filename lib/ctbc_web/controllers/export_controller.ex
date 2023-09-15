defmodule CtbcWeb.ExportController do
  use CtbcWeb, :controller

  alias Ctbc.Tickets

  def create(conn, _params) do
    fields = [
      :ticketid,
      :quantity,
      :ticket_type,
      :event_type,
      :status,
      :phone_number,
      :user_id,
      :event_id,
      :ticket_added_type,
      :promo_code_name,
      :promo_code_number,
      :total_cost,
      :ticket_holder_name
    ]

    csv_data = csv_content(Tickets.list_tickets(), fields)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"CtbcTickets.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, csv_data)
  end

  defp csv_content(records, fields) do
    records
    |> Enum.map(fn record ->
      record
      |> Map.from_struct()
      # gives an empty map
      |> Map.take([])
      |> Map.merge(Map.take(record, fields))
      |> Map.values()
    end)
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end
end
