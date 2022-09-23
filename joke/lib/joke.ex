defmodule Joke do
  @moduledoc """
  Documentation for `Joke`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Joke.hello()
      :world

  """
  def get_joke do
    request("https://official-joke-api.appspot.com/random_ten") |> Jason.decode() |> elem(1)
    # request("https://official-joke-api.appspot.com/random_joke") |> Jason.decode() |> elem(1)
  end

  def format_joke(joke) do
    IO.puts("Joke N " <> to_string(joke["id"]) <> " Type: " <> to_string(joke["type"]))
    IO.puts("- " <> joke["setup"])
    IO.puts("- " <> joke["punchline"])
    IO.puts("")
  end

  def print_joke do
    get_joke() |> Enum.each(fn x -> format_joke(x) end)
  end

  def request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # IO.puts(body)
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
