defmodule Mix.Tasks.IsHoliday do
  use Mix.Task

  @shortdoc "Returns Yes if today is a holiday, and No it it's not."
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:holiday)

    case Holiday.is_holiday() do
      true -> IO.puts("Yes")
      _ -> IO.puts("No")
    end
  end
end
