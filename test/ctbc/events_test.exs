defmodule Ctbc.EventsTest do
  use Ctbc.DataCase

  alias Ctbc.Events

  describe "events" do
    alias Ctbc.Events.Event

    import Ctbc.EventsFixtures

    @invalid_attrs %{name: nil, status: nil, type: nil, description: nil, image: nil, date_of_event: nil, time_of_starting: nil, time_of_ending: nil, price: nil, venue: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name", status: "some status", type: "some type", description: "some description", image: "some image", date_of_event: "some date_of_event", time_of_starting: "some time_of_starting", time_of_ending: "some time_of_ending", price: "some price", venue: "some venue"}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.status == "some status"
      assert event.type == "some type"
      assert event.description == "some description"
      assert event.image == "some image"
      assert event.date_of_event == "some date_of_event"
      assert event.time_of_starting == "some time_of_starting"
      assert event.time_of_ending == "some time_of_ending"
      assert event.price == "some price"
      assert event.venue == "some venue"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", type: "some updated type", description: "some updated description", image: "some updated image", date_of_event: "some updated date_of_event", time_of_starting: "some updated time_of_starting", time_of_ending: "some updated time_of_ending", price: "some updated price", venue: "some updated venue"}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.status == "some updated status"
      assert event.type == "some updated type"
      assert event.description == "some updated description"
      assert event.image == "some updated image"
      assert event.date_of_event == "some updated date_of_event"
      assert event.time_of_starting == "some updated time_of_starting"
      assert event.time_of_ending == "some updated time_of_ending"
      assert event.price == "some updated price"
      assert event.venue == "some updated venue"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
