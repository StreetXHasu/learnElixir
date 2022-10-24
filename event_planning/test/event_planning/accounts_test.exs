defmodule EventPlanning.AccountsTest do
  use EventPlanning.DataCase

  alias EventPlanning.Accounts

  describe "users" do
    alias EventPlanning.Accounts.User

    import EventPlanning.AccountsFixtures

    @invalid_attrs %{age: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{age: 42, name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.age == 42
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{age: 43, name: "some updated name"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.age == 43
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "events" do
    alias EventPlanning.Accounts.Event

    import EventPlanning.AccountsFixtures

    @invalid_attrs %{dEnd: nil, dStart: nil, description: nil, isActive: nil, name: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Accounts.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Accounts.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        dEnd: ~N[2022-10-15 11:37:00],
        dStart: ~N[2022-10-15 11:37:00],
        description: "some description",
        isActive: true,
        name: "some name"
      }

      assert {:ok, %Event{} = event} = Accounts.create_event(valid_attrs)
      assert event.dEnd == ~N[2022-10-15 11:37:00]
      assert event.dStart == ~N[2022-10-15 11:37:00]
      assert event.description == "some description"
      assert event.isActive == true
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        dEnd: ~N[2022-10-16 11:37:00],
        dStart: ~N[2022-10-16 11:37:00],
        description: "some updated description",
        isActive: false,
        name: "some updated name"
      }

      assert {:ok, %Event{} = event} = Accounts.update_event(event, update_attrs)
      assert event.dEnd == ~N[2022-10-16 11:37:00]
      assert event.dStart == ~N[2022-10-16 11:37:00]
      assert event.description == "some updated description"
      assert event.isActive == false
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_event(event, @invalid_attrs)
      assert event == Accounts.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Accounts.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Accounts.change_event(event)
    end
  end
end
