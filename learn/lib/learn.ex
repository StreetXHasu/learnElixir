defmodule Learn do
  require Logger

  @moduledoc """
  Documentation for `Learn`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Learn.hello()
      :world

  """
  def hello do
    IO.puts(["Hello World!"])
  end

  @spec is_palindrome(x :: integer) :: boolean
  def is_palindrome(x) do
    if x < 0 do
      false
    else
      array = Integer.digits(x)
      result = array == Enum.reverse(array)
      IO.puts(result)
    end
  end

  # task 2 start
  def roman_to_int(s) do
    result = parse(s)
    IO.puts(result)
  end

  def parse(input, total \\ 0)
  def parse("M" <> rest, total), do: parse(rest, total + 1000)
  def parse("CM" <> rest, total), do: parse(rest, total + 900)
  def parse("D" <> rest, total), do: parse(rest, total + 500)
  def parse("CD" <> rest, total), do: parse(rest, total + 400)
  def parse("C" <> rest, total), do: parse(rest, total + 100)
  def parse("XC" <> rest, total), do: parse(rest, total + 90)
  def parse("L" <> rest, total), do: parse(rest, total + 50)
  def parse("XL" <> rest, total), do: parse(rest, total + 40)
  def parse("X" <> rest, total), do: parse(rest, total + 10)
  def parse("IX" <> rest, total), do: parse(rest, total + 9)
  def parse("V" <> rest, total), do: parse(rest, total + 5)
  def parse("IV" <> rest, total), do: parse(rest, total + 4)
  def parse("I" <> rest, total), do: parse(rest, total + 1)
  def parse("", total), do: total

  # task 2 end

  ## task 3

  def is_valid_parentheses(s) do
    new_list = String.split(s, "", trim: true)
    data = do_valid_parentheses({[], [], new_list})

    case data do
      {open, close, s} ->
        # debug
        IO.puts('start')
        IO.puts(open)
        IO.puts(close)
        IO.puts(s)
        IO.puts('end')
        IO.puts('i loh x2')

      true ->
        IO.puts('good boy')
        true

      _ ->
        IO.puts('poor boy')
        false
    end
  end

  def do_valid_parentheses(data) do
    # {open, close, s} = data
    case data do
      {[], [], []} ->
        true

      {[], [], _} ->
        do_parse(data) |> do_valid_parentheses()

      {[], _, _} ->
        IO.puts('close is not empty')

      {_, [], _} ->
        do_parse(data) |> do_valid_parentheses()

      {_, _, []} ->
        now_time_valid_this(data) |> do_valid_parentheses()

      {_, _, _} ->
        do_parse(data) |> do_valid_parentheses()

      _ ->
        false
    end
  end

  def now_time_valid_this(data) do
    {open, close, s} = data

    map = %{
      ")" => "(",
      "]" => "[",
      "}" => "{"
    }

    check = {hd(open), map[hd(close)]}

    case check do
      {"(", "("} ->
        {tl(open), tl(close), s}

      {"[", "["} ->
        {tl(open), tl(close), s}

      {"{", "{"} ->
        {tl(open), tl(close), s}

      _ ->
        false
    end
  end

  def do_parse(data) do
    {open, close, s} = data

    if s != [] do
      case hd(s) do
        "(" ->
          new_open = List.insert_at(open, 0, hd(s))
          {new_open, close, tl(s)}

        ")" ->
          new_close = List.insert_at(close, 0, hd(s))
          {open, new_close, tl(s)}

        "[" ->
          new_open = List.insert_at(open, 0, hd(s))
          {new_open, close, tl(s)}

        "]" ->
          new_close = List.insert_at(close, 0, hd(s))
          {open, new_close, tl(s)}

        "{" ->
          new_open = List.insert_at(open, 0, hd(s))
          {new_open, close, tl(s)}

        "}" ->
          new_close = List.insert_at(close, 0, hd(s))
          {open, new_close, tl(s)}

        _ ->
          false
      end
    else
      false
    end
  end
end
