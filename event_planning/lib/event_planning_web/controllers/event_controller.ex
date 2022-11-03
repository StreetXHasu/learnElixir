defmodule EventPlanningWeb.EventController do
  use EventPlanningWeb, :controller

  alias EventPlanning.Accounts
  alias EventPlanning.Accounts.Event

  plug EventPlanningWeb.Plugs.FakeAuth

  def index(conn, _params) do
    events = Accounts.list_events()
    render(conn, "index.html", events: events)
  end

  @spec mySchedule(Plug.Conn.t(), any) :: Plug.Conn.t()
  def mySchedule(conn, %{"period" => period}) do
    case period do
      "week" ->
        myScheduleRender(conn, period)

      "month" ->
        myScheduleRender(conn, period)

      "year" ->
        myScheduleRender(conn, period)

      _ ->
        myScheduleRender(conn)
    end
  end

  def mySchedule(conn, _params) do
    myScheduleRender(conn)
  end

  defp myScheduleRender(conn, period \\ "week") do
    events = Accounts.list_events()
    render(conn, "my_schedule.html", events: events, period: period)
  end

  def nextEvent(conn, _params) do
    events = Accounts.list_events()
    render(conn, "next_event.html", events: events)
  end

  def new(conn, _params) do
    changeset = Accounts.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Accounts.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Accounts.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Accounts.get_event!(id)
    changeset = Accounts.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Accounts.get_event!(id)

    case Accounts.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Accounts.get_event!(id)
    {:ok, _event} = Accounts.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
