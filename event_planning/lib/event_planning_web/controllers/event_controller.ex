defmodule EventPlanningWeb.EventController do
  use EventPlanningWeb, :controller

  alias EventPlanning.Accounts
  alias EventPlanning.Accounts.Event

  plug EventPlanningWeb.Plugs.FakeAuth

  def index(conn, _params) do
    events = Accounts.list_events()
    render(conn, "index.html", events: events)
  end

  @spec my_schedule(Plug.Conn.t(), any) :: Plug.Conn.t()
  def my_schedule(conn, %{"period" => period}) do
    case period do
      "week" ->
        my_schedule_render(conn, period)

      "month" ->
        my_schedule_render(conn, period)

      "year" ->
        my_schedule_render(conn, period)

      _ ->
        my_schedule_render(conn)
    end
  end

  def my_schedule(conn, _params) do
    my_schedule_render(conn)
  end

  defp my_schedule_render(conn, period \\ "week") do
    {events, start, end_date} = Accounts.my_shedule(period)

    render(conn, "my_schedule.html",
      events: events,
      period: period,
      start: start,
      end_date: end_date
    )
  end

  def next_event(conn, _params) do
    {events, start, limit} = Accounts.next_event()

    render(conn, "next_event.html",
      events: events,
      start: start,
      limit: limit
    )
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Accounts.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Accounts.create_event(fix_end_datetime(event_params)) do
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

    event_params =
      Map.put(
        event_params,
        "repeat_days_week",
        event_params["repeat_days_week"]
      )

    case Accounts.update_event(event, fix_end_datetime(event_params)) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  defp fix_end_datetime(event_params) do
    # for test renders errors when data is invalid
    # my tests didn't pass so I added an if
    if !event_params["date_start"] or !event_params["date_end"] do
      event_params
    else
      Map.put(
        event_params,
        "date_end",
        Map.merge(event_params["date_start"], event_params["date_end"])
      )
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
