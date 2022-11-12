defmodule EventPlanningWeb.EventControllerTest do
  use EventPlanningWeb.ConnCase

  import EventPlanning.AccountsFixtures

  @create_attrs %{
    date_end: ~N[2022-10-15 11:37:00],
    date_start: ~N[2022-10-15 11:37:00],
    repeat: 0,
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    date_end: ~N[2022-10-16 11:37:00],
    date_start: ~N[2022-10-16 11:37:00],
    repeat: 0,
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{date_end: nil, date_start: nil, repeat: nil, description: nil, name: nil}
  @password "password"

  defp fake_auth(conn) do
    post(conn, Routes.login_path(conn, :new), %{"password" => %{"password" => @password}})
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = fake_auth(conn)

      conn = get(conn, Routes.event_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "my schedule" do
    test "my schedule", %{conn: conn} do
      conn = fake_auth(conn)

      conn = get(conn, Routes.event_path(conn, :my_schedule))
      assert html_response(conn, 200) =~ "My schedule"
    end
  end

  describe "next event" do
    test "next event", %{conn: conn} do
      conn = fake_auth(conn)

      conn = get(conn, Routes.event_path(conn, :next_event))
      assert html_response(conn, 200) =~ "Next Event"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = fake_auth(conn)
      conn = get(conn, Routes.event_path(conn, :new))
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = fake_auth(conn)
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.event_path(conn, :show, id)

      conn = fake_auth(conn)
      conn = get(conn, Routes.event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = fake_auth(conn)
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = fake_auth(conn)
      conn = get(conn, Routes.event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = fake_auth(conn)
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :show, event)

      conn = get(conn, Routes.event_path(conn, :show, event))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = fake_auth(conn)
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = fake_auth(conn)
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.event_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
