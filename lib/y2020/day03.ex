defmodule Y2020.Day03 do
  use Advent.Day, no: 3

  @doc """
  iex> Day03.part1("..##.......\\n#...#...#..\\n.#....#..#.\\n..#.#...#.#\\n.#...##..#.\\n..#.##.....\\n
  ...>.#.#.#....#\\n.#........#\\n#.##...#...\\n#...##....#\\n.#..#...#.#")
  %{trees: 7, open: 3}
  """
  def part1(input, right_step \\ 3, down_step \\ 1) do
    input
    |> parse_input
    |> make_step({0, 0}, {right_step, down_step}, %{trees: 0, open: 0})
  end

  # End case - have stepped to the bottom of the grid
  defp make_step({rows, _cols, _grid}, {cur_row, _cur_col}, _steps, progress)
       when cur_row == rows - 1 do
    progress
  end

  defp make_step({_, cols, grid} = state, {cur_row, cur_col}, {right_step, down_step}, %{
         trees: trees,
         open: open
       }) do
    new_row = cur_row + down_step
    new_col = rem(cur_col + right_step, cols)

    progress =
      if(MapSet.member?(grid, {new_row, new_col})) do
        %{trees: trees + 1, open: open}
      else
        %{trees: trees, open: open + 1}
      end

    make_step(state, {new_row, new_col}, {right_step, down_step}, progress)
  end

  @doc """
  iex> Day03.parse_input("..##.......\\n#...#...#..")
  {2, 11, MapSet.new([{0,2}, {0,3}, {1,0}, {1,4}, {1,8}])}
  """
  def parse_input(input) do
    rows =
      input
      |> String.split("\n", trim: true)

    set =
      rows
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), &parse_row/2)

    {length(rows), String.length(hd(rows)), set}
  end

  defp parse_row({row, row_no}, set) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(set, fn {col, col_no}, acc ->
      parse_cell(col, row_no, col_no, acc)
    end)
  end

  defp parse_cell(".", _, _, set), do: set
  defp parse_cell("#", row, col, set), do: MapSet.put(set, {row, col})

  def part1_verify, do: input() |> part1() |> Map.get(:trees)
end
