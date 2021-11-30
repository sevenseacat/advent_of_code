defmodule Y2015.Day03 do
  use Advent.Day, no: 3

  @doc """
  iex> Day03.part1(">")
  2

  iex> Day03.part1("^>v<")
  4

  iex> Day03.part1("^v^v^v^v^v")
  2
  """
  def part1(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(starting_state(), &move/2)
    |> hd
    |> Enum.count()
  end

  def part2(input) do
    moves = String.graphemes(input)

    santa_moves = Enum.drop_every(moves, 2)
    robosanta_moves = Enum.take_every(moves, 2)

    santa_grid = Enum.reduce(santa_moves, starting_state(), &move/2) |> hd
    final_grid = Enum.reduce(robosanta_moves, [santa_grid, {0, 0}], &move/2) |> hd

    Enum.count(final_grid)
  end

  defp starting_state, do: [%{{0, 0} => 1}, {0, 0}]

  defp move("^", [grid, {x, y}]), do: add_to_grid(grid, {x, y + 1})
  defp move("v", [grid, {x, y}]), do: add_to_grid(grid, {x, y - 1})
  defp move("<", [grid, {x, y}]), do: add_to_grid(grid, {x - 1, y})
  defp move(">", [grid, {x, y}]), do: add_to_grid(grid, {x + 1, y})

  defp add_to_grid(grid, position) do
    new_grid = Map.update(grid, position, 1, &(&1 + 1))
    [new_grid, position]
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
