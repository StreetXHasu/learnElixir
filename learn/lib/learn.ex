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
    IO.puts(["hello"])
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

  #task 2 start
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

  #task 2 end


end
