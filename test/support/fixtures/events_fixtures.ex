defmodule Ctbc.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ctbc.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status",
        type: "some type",
        description: "some description",
        image: "some image",
        date_of_event: "some date_of_event",
        time_of_starting: "some time_of_starting",
        time_of_ending: "some time_of_ending",
        price: "some price",
        venue: "some venue"
      })
      |> Ctbc.Events.create_event()

    event
  end
end
