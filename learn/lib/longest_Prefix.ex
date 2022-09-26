defmodule Longest_prefix do
  require Logger

  def start do
    # String.length()
    # |> IO.puts()

    longest_common_prefix(["flower","flow","flight"])
    |> IO.puts()
  end

  @spec longest_common_prefix(strs :: [String.t()]) :: String.t()
  def longest_common_prefix(strs) do
    for str <- strs do
      for {symbol, index} <- to_charlist(str) |> Enum.with_index() do
        for str2 <- strs do
          for {symbol2, index2} <- to_charlist(str2) |> Enum.with_index() do
            # IO.puts("#{symbol} - #{symbol2}")
            Enum.sum([index2])
            symbol2 == symbol
          end
          |> Enum.at(index)
        end
        |> Enum.all?()
      end
    end
    |> checker(strs |> hd)
  end

  def checker(data, strs, prefix \\ "") do
    # IO.puts(strs |> Enum.at(length(prefix)) |> Enum.at(1) |> String.to_charlist())

    case {data, prefix} do
      {[], []} ->
        IO.puts("empty")
        ""

      {[], _} ->
        # IO.puts("end")
        IO.puts(String.length(prefix))
        prefix

      {_, _} ->
        # data
        # strs
        # IO.puts("LOOP")

        check =
          Enum.all?(data, fn elem ->
            # IO.puts(elem |> hd)
            if length(elem) >= 1 do
              elem |> hd == true
            else
              false
            end
          end)

        if check do
          for old_data <- data do
            Enum.drop(old_data, 1)
          end
          |> checker(
            strs,
            prefix <> String.at(strs, String.length(prefix))
          )
        else
          checker([], strs, prefix)
        end

      _ ->
        ## i tak skazal
        "nil"
    end
  end
end

# true
#   for {symbol2, index2} <- to_charlist(str2) |> Enum.with_index(),
#   symbol2 === symbol , do
#     true
#   end
#   do
# symbol
# for str2 <- strs do
#   IO.puts(str2)
#   true
#   end
