defmodule Y2024.Day14 do
  use Advent.Day, no: 14

  def part1(input, size, ticks \\ 100) do
    # Count up to reach the set number of ticks
    win_state = fn {_, _, current} -> current == ticks end

    input
    |> tick(size, win_state, 0)
    |> elem(0)
    |> quadrantize(size)
  end

  def part2(input, size) do
    # Count up until you see a treeeeee!?!?!?
    trees =
      [
        "1111111111111111111111111111111",
        "1                             1",
        "1                             1",
        "1                             1",
        "1                             1",
        "1              1              1",
        "1             111             1",
        "1            11111            1",
        "1           1111111           1",
        "1          111111111          1",
        "1            11111            1",
        "1           1111111           1",
        "1          111111111          1",
        "1         11111111111         1",
        "1        1111111111111        1",
        "1          111111111          1",
        "1         11111111111         1",
        "1        1111111111111        1",
        "1       111111111111111       1",
        "1      11111111111111111      1",
        "1        1111111111111        1",
        "1       111111111111111       1",
        "1      11111111111111111      1",
        "1     1111111111111111111     1",
        "1    111111111111111111111    1",
        "1             111             1",
        "1             111             1",
        "1             111             1",
        "1                             1",
        "1                             1",
        "1                             1",
        "1                             1",
        "1111111111111111111111111111111"
      ]
      |> Enum.with_index()

    win_state = fn {input, {max_row, max_col}, current} ->
      # After lots of trial and error printing out the grid after a set number
      # of ticks, there seem to be cycles where it looks like robots are coming
      # together at given points - the two tick number conditions below
      # One of those must be right answer
      if rem(current, 103) == 31 || rem(current, 101) == 88 do
        # Turn the robot list into a grid shape
        grid =
          input
          |> Enum.group_by(& &1.position)
          |> Enum.map(fn {{row, col}, list} -> {{col, row}, length(list)} end)
          |> Map.new()

        coords = for row <- 0..(max_row - 1), col <- 0..(max_col - 1), do: {col, row}

        row_strings =
          coords
          |> Enum.map(fn coord -> {coord, Map.get(grid, coord, " ")} end)
          |> Map.new()
          |> Advent.Grid.rows()
          |> Enum.with_index()
          |> Map.new(fn {row, index} -> {index, row} end)

        # The real logic - find out if all of the rows in the `trees` list
        # are found at the same starting index in any row of the grid
        # https://stackoverflow.com/a/35551220
        Enum.find(row_strings, fn {row_index, row} ->
          {head_tree, _} = hd(trees)

          case :binary.match(row, head_tree) do
            :nomatch ->
              false

            {col_index, length} ->
              # The first tree row is found in the current grid, now are all of
              # the other rows of the tree found in subsequent rows of the grid?
              Enum.all?(trees, fn {tree_row, tree_index} ->
                {col_index, length} ==
                  row_strings
                  |> Map.get(row_index + tree_index, "")
                  |> :binary.match(tree_row)
              end)
          end
        end)
      end
    end

    input
    |> tick(size, win_state, 0)
    |> elem(1)
  end

  defp tick(input, {max_row, max_col}, win_condition, ticks) do
    if win_condition.({input, {max_row, max_col}, ticks}) do
      {input, ticks}
    else
      input
      |> Enum.map(fn %{position: {row, col}, velocity: {v_row, v_col}} ->
        new_position = {rem(row + v_row + max_row, max_row), rem(col + v_col + max_col, max_col)}
        %{position: new_position, velocity: {v_row, v_col}}
      end)
      |> tick({max_row, max_col}, win_condition, ticks + 1)
    end
  end

  defp quadrantize(input, {row, col}) do
    middle_row = div(row, 2)
    middle_col = div(col, 2)

    input
    |> Enum.reject(fn %{position: {row, col}} -> row == middle_row || col == middle_col end)
    |> Enum.group_by(fn %{position: {row, col}} ->
      {row > middle_row, col > middle_col}
    end)
    |> Enum.reduce(1, fn {_, list}, acc -> acc * length(list) end)
  end

  @doc "Display the grid to see what's going on."
  def display(input, {max_row, max_col}) do
    IO.puts("")

    new_input =
      input
      |> Enum.group_by(& &1.position)
      |> Enum.map(fn {{row, col}, list} -> {{col, row}, length(list)} end)
      |> Map.new()

    coords = for row <- 0..(max_row - 1), col <- 0..(max_col - 1), do: {col, row}

    coords
    |> Enum.map(fn coord -> {coord, Map.get(new_input, coord, " ")} end)
    |> Map.new()
    |> Advent.Grid.display()

    input
  end

  @doc """
  iex> Day14.parse_input("p=0,4 v=3,-3\\np=6,3 v=-1,-3\\n")
  [%{position: {0,4}, velocity: {3, -3}}, %{position: {6, 3}, velocity: {-1, -3}}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      ["", row, col, v_row, v_col] = String.split(row, ["p=", ",", " v="])

      %{
        position: {String.to_integer(row), String.to_integer(col)},
        velocity: {String.to_integer(v_row), String.to_integer(v_col)}
      }
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1({101, 103}, 100)
  def part2_verify, do: input() |> parse_input() |> part2({101, 103})
end
