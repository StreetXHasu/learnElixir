defmodule EventPlanning.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EventPlanning.Repo

  alias EventPlanning.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias EventPlanning.Accounts.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  defp my_shedule_query(date_start, date_end) do
    result =
      Repo.all(
        from e in Event,
          where:
            (e.date_start >= ^date_start and
               e.date_start < ^date_end) or
              e.repeat != :disabled,
          order_by: e.date_start
      )

    IO.inspect(date_start)
    IO.inspect(date_end)

    result
    |> event_repeat()
    |> event_collision()
    |> Enum.filter(fn x ->
      NaiveDateTime.diff(x.date_start, date_end, :second)
      NaiveDateTime.diff(x.date_start, date_end, :second)

      cond do
        NaiveDateTime.diff(x.date_start, date_start, :second) >= 0 and
            NaiveDateTime.diff(date_end, x.date_start, :second) >= 0 ->
          true

        true ->
          false
      end
    end)
    |> Enum.sort_by(& &1.date_start, Date)
  end

  defp event_collision(events) do
    events
    |> Enum.map(fn x ->
      color =
        Enum.any?(events, fn y ->
          if(
            x.date_start <= y.date_end and y.date_start <= x.date_end and
              x.id != y.id
          ) do
            true
          end
        end)

      Map.put(x, :color, color)
    end)
  end

  defp event_dublicate(event, seconds_in_period) do
    counter =
      (NaiveDateTime.diff(event.repeat_date_end, event.date_start, :second) / seconds_in_period)
      |> trunc

    repeat =
      for w <- 0..counter do
        if w > 0 do
          date_start = NaiveDateTime.add(event.date_start, seconds_in_period * w)
          date_end = NaiveDateTime.add(event.date_end, seconds_in_period * w)

          Map.put(event, :date_start, date_start)
          |> Map.put(:date_end, date_end)
        end
      end

    [event | repeat] |> Enum.filter(&(!is_nil(&1)))
  end

  defp event_repeat(events) do
    map_week = %{
      "monday" => 1,
      "tuesday" => 2,
      "wednesday" => 3,
      "thursday" => 4,
      "friday" => 5,
      "saturday" => 6,
      "sunday" => 7,
      nil => nil
    }

    Enum.flat_map(events, fn x ->
      case x.repeat do
        :day ->
          event_dublicate(x, 86400)

        :week ->
          event_dublicate(x, 86400)
          |> Enum.filter(fn x2 ->
            x |> IO.inspect()

            cond do
              x.date_start == x2.date_start ->
                true

              x.repeat_days_week == nil ->
                Date.day_of_week(x.date_start) == Date.day_of_week(x2.date_start)

              Enum.member?(
                Enum.map(x.repeat_days_week, fn r -> map_week[r] end),
                Date.day_of_week(x2.date_start)
              ) ->
                true

              true ->
                false
            end
          end)

        :month ->
          event_dublicate(x, 86400 * 30)

        :year ->
          event_dublicate(x, 86400 * 365)

        _ ->
          [x]
      end
    end)
  end

  def my_shedule("week") do
    start_date = DateTime.utc_now() |> Date.beginning_of_week()
    {:ok, start_date_native} = start_date |> NaiveDateTime.new(~T[00:00:00])

    {:ok, end_date_native} = start_date |> Date.add(7) |> NaiveDateTime.new(~T[00:00:00])

    events = my_shedule_query(start_date_native, end_date_native)

    {events, start_date, end_date_native |> NaiveDateTime.to_date() |> Date.add(-1)}
  end

  def my_shedule("month") do
    start_date = DateTime.utc_now() |> Date.beginning_of_month()

    {:ok, start_date_native} = start_date |> NaiveDateTime.new(~T[00:00:00])

    {:ok, end_date_native} = start_date |> Date.end_of_month() |> NaiveDateTime.new(~T[00:00:00])

    events = my_shedule_query(start_date_native, end_date_native)

    {events, start_date, end_date_native |> NaiveDateTime.to_date()}
  end

  def my_shedule("year") do
    today = Date.utc_today()
    year = today.year
    {:ok, start_date_native} = NaiveDateTime.new(year, 1, 1, 0, 0, 0)
    {:ok, end_date_native} = NaiveDateTime.new(year + 1, 1, 1, 0, 0, 0)

    events = my_shedule_query(start_date_native, end_date_native)

    {events, start_date_native |> NaiveDateTime.to_date(),
     end_date_native |> NaiveDateTime.to_date()}
  end

  def my_shedule(_) do
    my_shedule("week")
  end

  def next_event() do
    limit = 25
    start_date = DateTime.utc_now() |> Date.beginning_of_month()

    {:ok, start_date_native} = start_date |> NaiveDateTime.new(~T[00:00:00])

    result =
      Repo.all(
        from e in Event,
          where:
            e.date_start >= ^start_date_native or
              e.repeat != :disabled,
          order_by: e.date_start,
          limit: ^limit
      )

    events =
      result
      |> event_repeat()
      |> event_collision()
      |> Enum.sort_by(& &1.date_start, Date)
      |> Enum.take(limit)

    {events, start_date, limit}
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end
