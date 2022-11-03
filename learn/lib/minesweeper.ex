defmodule Minesweeper do
  require Logger
  ## mix run -e Minesweeper.start
  def start do
    IO.puts("start Minesweeper")
    board = ['MEEEE', 'EEEEE', 'EEEEE', 'EEEEE']
    click = [2, 3]
    return = Solution.update_board(board, click)
    # debug
    m = length(board)
    n = board |> hd |> List.to_string() |> String.length()
    IO.puts("m = #{m}")
    IO.puts("n = #{n}")
    click_x = click |> hd
    click_y = click |> tl |> hd
    IO.puts("x = #{click_x}")
    IO.puts("y = #{click_y}")
    # print board
    Enum.each(return, fn x ->
      IO.puts(x)
    end)

    IO.puts("finish Minesweeper")
  end
end

defmodule Solution do
  @spec update_board(board :: [[char]], click :: [integer]) :: [[char]]
  def update_board(board, click) do
    click_x = click |> hd
    click_y = click |> tl |> hd

    board = map_decode(board)
    # IO.puts(board)

    if board |> cell_get(click_x, click_y) == "M" do
      IO.puts("Game Over")
      board |> cell_edit(click_x, click_y, 88) |> map_encode
    else
      board |> dfs(click_x, click_y) |> map_encode
    end
  end

  def dfs(board, click_x, click_y) do
    # IO.puts("DFS Start")

    cond do
      board |> inboard(click_x, click_y) == false ->
        # IO.puts("x(#{click_x}) y(#{click_y}) OUT BOARD")
        board

      board |> cell_get(click_x, click_y) == "B" ->
        # IO.puts("x(#{click_x}) y(#{click_y}) == B")
        board

      true ->
        count = counter(board, click_x, click_y)

        if count > 0 do
          # IO.puts("DFS END")
          board |> cell_edit(click_x, click_y, to_string(count))
        else
          new_board = board |> cell_edit(click_x, click_y, 66)

          dfs(new_board, click_x - 1, click_y - 1)
          |> dfs(click_x - 1, click_y)
          |> dfs(click_x - 1, click_y + 1)
          |> dfs(click_x, click_y - 1)
          |> dfs(click_x, click_y + 1)
          |> dfs(click_x + 1, click_y - 1)
          |> dfs(click_x + 1, click_y)
          |> dfs(click_x + 1, click_y + 1)
        end
    end
  end

  def counter(board, click_x, click_y, blocker \\ [], sum \\ 0) do
    # super netural contuction, plase help me&!77171&!&
    cond do
      board |> inboard(click_x - 1, click_y - 1) && "x-1 y-1" not in blocker &&
          board |> cell_get(click_x - 1, click_y - 1) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x-1 y-1"], sum + 1)

      board |> inboard(click_x - 1, click_y) && "x-1 y" not in blocker &&
          board |> cell_get(click_x - 1, click_y) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x-1 y"], sum + 1)

      board |> inboard(click_x - 1, click_y + 1) && "x-1 y+1" not in blocker &&
          board |> cell_get(click_x - 1, click_y + 1) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x-1 y+1"], sum + 1)

      board |> inboard(click_x, click_y - 1) && "x y-1" not in blocker &&
          board |> cell_get(click_x, click_y - 1) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x y-1"], sum + 1)

      board |> inboard(click_x, click_y + 1) && "x y+1" not in blocker &&
          board |> cell_get(click_x, click_y + 1) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x y+1"], sum + 1)

      board |> inboard(click_x + 1, click_y - 1) && "x+1 y-1" not in blocker &&
          board |> cell_get(click_x + 1, click_y - 1) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x+1 y-1"], sum + 1)

      board |> inboard(click_x + 1, click_y) && "x+1 y" not in blocker &&
          board |> cell_get(click_x + 1, click_y) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x+1 y"], sum + 1)

      board |> inboard(click_x + 1, click_y + 1) && "x+1 y+1" not in blocker &&
          board |> cell_get(click_x + 1, click_y + 1) == "M" ->
        counter(board, click_x, click_y, blocker ++ ["x+1 y+1"], sum + 1)

      true ->
        sum
    end
  end

  def inboard(board, click_x, click_y) do
    m = length(board)
    n = board |> hd |> elem(1) |> length()

    if click_x >= 0 && click_x < m && click_y >= 0 && click_y < n do
      true
    else
      false
    end
  end

  def cell_get(board, click_x, click_y) do
    cell = board |> Enum.at(click_x) |> elem(1) |> Enum.at(click_y) |> elem(1) |> map_char
    # IO.puts("x(#{click_x}) y(#{click_y}) cell = #{cell}")
    cell
  end

  def cell_edit(board, click_x, click_y, new_data) do
    row = board |> Enum.at(click_x)

    cell =
      board
      |> Enum.at(click_x)
      |> elem(1)
      |> Enum.at(click_y)
      |> put_elem(1, new_data)

    new_column = row |> elem(1) |> List.replace_at(click_y, cell)
    new_column = {click_x, new_column}
    new_board = board |> List.replace_at(click_x, new_column)
    new_board |> cell_get(click_x, click_y)
    new_board
  end

  def map_char(int) do
    %{
      "1" => "1",
      "2" => "2",
      "3" => "3",
      "4" => "4",
      "5" => "5",
      "6" => "6",
      "7" => "7",
      "8" => "8",
      66 => "B",
      69 => "E",
      77 => "M",
      88 => "X"
    }[int]
  end

  def map_decode(board) do
    Enum.with_index(board, fn element, index ->
      {index,
       element
       |> List.to_charlist()
       |> Enum.with_index(fn element2, index2 -> {index2, element2} end)}
    end)
  end

  def map_encode(board) do
    Enum.with_index(board, fn element, index ->
      List.to_charlist(
        element
        |> elem(1)
        |> Enum.with_index(fn element2, index2 ->
          # trash 2 line
          Enum.sum(index)
          Enum.sum(index2)
          # ok
          elem(element2, 1)
        end)
      )
    end)
  end
end
