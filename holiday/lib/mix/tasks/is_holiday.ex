defmodule Mix.Tasks.IsHoliday do
  use Mix.Task

  @shortdoc "Returns Yes if today is a holiday, and No it it's not."
  def run(_) do
    db = Holiday.init_db()

    case Holiday.is_holiday(db) do
      true -> IO.puts("Yes")
      _ -> IO.puts("No")
    end
  end
end
