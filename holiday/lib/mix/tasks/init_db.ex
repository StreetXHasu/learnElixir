defmodule Mix.Tasks.InitDb do
  use Mix.Task

  @shortdoc "Seed database."
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:holiday)

    case Holiday.init_db() do
      true -> IO.puts("Completed")
      _ -> IO.puts("Error")
    end
  end
end
