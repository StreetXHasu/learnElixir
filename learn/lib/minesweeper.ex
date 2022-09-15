defmodule Minesweeper do
  require Logger

  def start do
    IO.puts("start Minesweeper")
    return = Solution.update_board(['EEEEE', 'EEMEE', 'EEEEE', 'EEEEE'], [3, 0])
    Enum.each(return, fn x -> IO.puts(x) end)
    IO.puts("finish Minesweeper")
  end
end

defmodule Solution do
  @spec update_board(board :: [[char]], click :: [integer]) :: [[char]]
  def update_board(board, click) do
    m = length(board)
    n = board |> hd |> List.to_string() |> String.length()
    IO.puts(m)
    IO.puts(n)
    board
  end
end
