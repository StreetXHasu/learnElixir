defmodule Holiday do
  import Ecto.Query
  alias Holiday.{Repo, Event}

  @moduledoc """
  Documentation for `Holiday`.
  """

  @doc """
  Initializing the local database.

  """
  @spec init_db() :: []
  def init_db() do
    path = Path.expand("lib/us-california-nonworkingdays.ics")

    {:ok, binary} = File.read(path)

    Enum.each(binary |> ICalendar.from_ics(), fn event ->

      result =
        case Repo.get_by(Event, uid: event.uid) do
          nil -> %Event{uid: event.uid}
          myEvent -> myEvent
        end
        |> Ecto.Changeset.change(%{
          uid: event.uid,
          title: event.summary,
          dStart: %{DateTime.to_date(event.dtstart) | year: 1970},
          dEnd: %{DateTime.to_date(event.dtend) | year: 1970},
          rules: event.rrule,
          isConfirmed: event.status == "confirmed"
        })
        |> Holiday.Repo.insert_or_update()

      case result do
        {:ok, struct} ->
          {:ok, struct}

        {:error, changeset} ->
          {:error, changeset}
      end
    end)

    true
  end

  @doc """
  Returns true if today is a holiday, and false it it's not..

  ## Parameters

    - day: Date that represents the default is today's date or a user-specified date.

  ## Examples

      iex> Holiday.is_holiday(~D[2000-01-01])
      true

  """
  @spec is_holiday(day :: %Date{}) :: boolean()
  def is_holiday(day \\ Date.utc_today()) do
    Repo.exists?(from(e in Event, where: e.dStart == ^make_start_date(day)))
  end

  defp getOneEvent(day, recursion \\ true) do
    result =
      Repo.one(
        from(
          e in Event,
          where: e.dStart > ^day,
          order_by: [asc: e.dStart],
          limit: 1
        )
      )

    unless result do
      if recursion && getOneEvent(make_start_date(day, 1969), false), do: true, else: false
    end

    result
  end

  @doc """
  Return a float representing a number of `units till closest holiday in the future.

  ## Parameters

    - unit: Atom. Can be one of :day | :hour | :minute | :second
    - now: Date that represents the default is today's date or a user-specified date.

  ## Examples

      iex> Holiday.time_until_holiday(:day, ~U[2022-01-12 00:01:00.00Z])
      19.999305555555555

      iex> Holiday.time_until_holiday(:hour, ~U[2022-01-12 00:01:00.00Z])
      479.98333333333335

  """
  @spec time_until_holiday(
          unit :: :day | :hour | :minute | :second,
          now :: %DateTime{}
        ) :: float()
  def time_until_holiday(unit, now \\ DateTime.utc_now())

  def time_until_holiday(:day, now) do
    find_nearest(now) / 60 / 60 / 24
  end

  def time_until_holiday(:hour, now) do
    find_nearest(now) / 60 / 60
  end

  def time_until_holiday(:minute, now) do
    find_nearest(now) / 60
  end

  def time_until_holiday(:second, now) do
    find_nearest(now)
  end

  @doc """
  Displays all holidays in the database in the format: Holiday Name: Start Date - End Date.


  ## Examples

      iex> Holiday.show_all_events()
      true

  """
  @spec show_all_events() :: []
  def show_all_events() do
    query = from(e in Event)

    db = Repo.all(query)

    for event <- db do
      IO.puts("#{event.title}: #{event.dStart} - #{event.dEnd}")
      event
    end

    true
  end

  defp make_start_date(date, year \\ 1970) do
    Date.new(year, date.month, date.day) |> elem(1)
  end

  defp make_fake_date_time(%Date{} = date) do
    time = Time.new(0, 0, 0, 0) |> elem(1)

    DateTime.new(date, time)
    |> elem(1)
  end

  defp make_fake_date_time(%DateTime{} = date) do
    %{date | year: 1970}
  end

  defp find_nearest(date) do
    new_date = date |> make_fake_date_time

    getOneEvent(DateTime.to_date(new_date) |> make_start_date()).dStart
    |> make_start_date
    |> make_fake_date_time
    |> DateTime.diff(new_date)
  end
end
