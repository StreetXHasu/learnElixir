defmodule Holiday do
  def start do
    IO.puts("hi world")
    person = %Holiday.Person{name: "Bob"}
    Holiday.Repo.insert(person)

    true
  end

  @moduledoc """
  Documentation for `Holiday`.
  """

  @doc """
  Initializing the local database.

  """
  @spec init_db() :: [%ICalendar.Event{}]
  def init_db() do
    path = Path.expand("lib/us-california-nonworkingdays.ics")

    case File.read(path) do
      {:ok, binary} -> binary |> ICalendar.from_ics()
      _ -> false
    end
  end

  @doc """
  Returns true if today is a holiday, and false it it's not..
  First arg is result of calling `init_db()`.

  ## Parameters

    - db: List of %ICalendar.Event{} that represents the event database.
    - day: Date that represents the default is today's date or a user-specified date.

  ## Examples

      iex> Holiday.is_holiday(Holiday.init_db(), ~D[2000-01-01])
      true

  """
  @spec is_holiday(db :: [%ICalendar.Event{}], day :: %Date{}) :: boolean()
  def is_holiday(db, day \\ Date.utc_today()) do
    Enum.any?(db, fn event ->
      compare_date(event.dtstart, day)
    end)
  end

  @doc """
  Return a float representing a number of `units till closest holiday in the future.

  ## Parameters

    - db: List of %ICalendar.Event{} that represents the event database.
    - unit: Atom. Can be one of :day | :hour | :minute | :second
    - now: Date that represents the default is today's date or a user-specified date.

  ## Examples

      iex> Holiday.time_until_holiday(Holiday.init_db(),:day,~U[2022-01-12 00:01:00.00Z])
      19.999305555555555

      iex> Holiday.time_until_holiday(Holiday.init_db(),:hour,~U[2022-01-12 00:01:00.00Z])
      479.98333333333335

  """
  @spec time_until_holiday(
          db :: %ICalendar.Event{},
          unit :: :day | :hour | :minute | :second,
          now :: %DateTime{}
        ) :: float()
  def time_until_holiday(db, unit, now \\ DateTime.utc_now())

  def time_until_holiday(db, :day, now) do
    find_nearest(db, now) / 60 / 60 / 24
  end

  def time_until_holiday(db, :hour, now) do
    find_nearest(db, now) / 60 / 60
  end

  def time_until_holiday(db, :minute, now) do
    find_nearest(db, now) / 60
  end

  def time_until_holiday(db, :second, now) do
    find_nearest(db, now)
  end

  @doc """
  Displays all holidays in the database in the format: Holiday Name: Start Date - End Date.

  ## Parameters

    - db: List of %ICalendar.Event{} that represents the event database.

  ## Examples

      iex> Holiday.show_all_events(Holiday.init_db())
      true

  """
  @spec show_all_events(db :: [%ICalendar.Event{}]) :: []
  def show_all_events(db) do
    for event <- db do
      # IO.puts(compare_date(event.dtstart, Date.new(2000, 6, 1) |> elem(1)))
      IO.puts("#{event.summary}: #{event.dtstart} - #{event.dtend}")
      event
    end

    true
  end

  defp compare_date(date1, date2) do
    Date.new(2000, date1.month, date1.day) == Date.new(2000, date2.month, date2.day)
  end

  defp make_start_date(date) do
    new = Date.new(2000, date.month, date.day) |> elem(1)

    if new.day == 1 and new.month == 1 do
      Date.new(2000 + 1, date.month, date.day) |> elem(1)
    else
      new
    end
  end

  defp make_fake_date_time(%Date{} = date) do
    time = Time.new(0, 0, 0, 0) |> elem(1)

    DateTime.new(date, time)
    |> elem(1)
  end

  defp make_fake_date_time(%DateTime{} = date) do
    %{date | year: 2000}
  end

  defp find_nearest(db, date) do
    new_date = date |> make_fake_date_time

    Enum.min_by(db, fn event ->
      if Date.diff(make_start_date(event.dtstart), new_date) > 0 do
        Date.diff(make_start_date(event.dtstart), new_date)
      end
    end).dtstart
    |> make_start_date
    |> make_fake_date_time
    |> DateTime.diff(new_date)
  end
end
