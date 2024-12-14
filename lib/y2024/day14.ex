defmodule Y2024.Day14 do
  use Advent.Day, no: 14

  def part1(input, size, ticks \\ 100) do
    input
    |> tick(size, ticks)
    |> quadrantize(size)
  end

  defp tick(input, _size, 0), do: input

  defp tick(input, {max_row, max_col}, ticks) do
    Enum.map(input, fn %{position: {row, col}, velocity: {v_row, v_col}} ->
      new_position = {rem(row + v_row + max_row, max_row), rem(col + v_col + max_col, max_col)}
      %{position: new_position, velocity: {v_row, v_col}}
    end)
    |> tick({max_row, max_col}, ticks - 1)
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

  # @doc """
  # iex> Day14.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

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
    |> Enum.map(fn coord -> {coord, Map.get(new_input, coord, ".")} end)
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

  def part1_verify, do: input() |> parse_input() |> part1({101, 103})
  # def part2_verify, do: input() |> parse_input() |> part2()
end
