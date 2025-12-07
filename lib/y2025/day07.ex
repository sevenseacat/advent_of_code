defmodule Y2025.Day07 do
  use Advent.Day, no: 07

  alias Advent.Grid

  def part1(input) do
    input
    |> do_parts(false)
    |> elem(1)
  end

  def part2(input) do
    {max_row, _} = Grid.size(input)

    input
    |> do_parts(true)
    |> elem(0)
    |> Enum.filter(fn {{row, _col}, _val} -> row == max_row end)
    |> Enum.sum_by(fn {_coord, val} ->
      if val == "." do 0 else val end
    end)
  end

  defp do_parts(input, recount?) do
    coord = Enum.find(input, fn {_coord, char} -> char == "S" end) |> elem(0)
    run_beams({Map.put(input, coord, 1), MapSet.new([coord]), 0}, recount?)
  end

  defp run_beams({grid, beams, split_count}, recount?) do
    if MapSet.size(beams) == 0 do
      {grid, split_count}
    else
      beams
      |> Enum.reduce({grid, MapSet.new(), split_count}, fn {row, col}, {grid, beams, split_count} ->
        current = Map.get(grid, {row, col})
        next = {row + 1, col}

        case Map.get(grid, next) do
          "^" ->
            next = [{row + 1, col - 1}, {row + 1, col + 1}]
            grid = Enum.reduce(next, grid, &increment(&2, &1, current))
            {grid, MapSet.union(beams, MapSet.new(next)), split_count + 1}

          "." ->
            grid = increment(grid, next, current)
            {grid, MapSet.put(beams, next), split_count}

          num when is_number(num) ->
            grid = increment(grid, next, current)

            beams =
              if recount? do
                MapSet.put(beams, next)
              else
                beams
              end

            {grid, beams, split_count}

          _ ->
            {grid, beams, split_count}
        end
      end)
      |> run_beams(recount?)
    end
  end

  defp increment(grid, coord, current) do
    Map.update!(grid, coord, fn
      "." -> current
      num when is_number(num) -> num + current
    end)
  end

  def parse_input(input) do
    Grid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
