defmodule Y2025.Day07 do
  use Advent.Day, no: 07

  alias Advent.Grid

  def part1(input) do
    beam = Enum.find(input, fn {_coord, char} -> char == "S" end) |> elem(0)
    run_beams({input, [beam], 0})
  end

  # @doc """
  # iex> Day07.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp run_beams({_grid, [], split_count}), do: split_count

  defp run_beams({grid, beams, split_count}) do
    beams
    |> Enum.reduce({grid, [], split_count}, fn {row, col}, {grid, beams, split_count} ->
      next = {row + 1, col}

      case Map.get(grid, next) do
        "^" ->
          next = [{row + 1, col - 1}, {row + 1, col + 1}]
          grid = Enum.reduce(next, grid, &Map.put(&2, &1, "|"))

          # Grid.display(grid, [{row+1, col-1}, {row+1, col+1}])
          {grid, Enum.concat(next, beams), split_count + 1}

        "." ->
          grid = Map.put(grid, next, "|")

          # Grid.display(grid, [next])
          {grid, [next | beams], split_count}

        _ ->
          {grid, beams, split_count}
      end
    end)
    |> run_beams()
  end

  def parse_input(input) do
    Grid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  #  def part2_verify, do: input() |> parse_input() |> part2()
end
