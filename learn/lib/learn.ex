defmodule Learn do
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

  @spec roman_to_int(s :: String.t) :: integer
  def roman_to_int(s) do
    result = Enum.map([10,  20], fn (v) -> {v} end)
    IO.puts(result)
  end
end
