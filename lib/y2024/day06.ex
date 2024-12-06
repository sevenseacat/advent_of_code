defmodule Y2024.Day06 do
  use Advent.Day, no: 06
  alias Advent.Grid

  def part1(grid) do
    {grid, guard} = find_guard(grid)

    move(grid, guard, :up, MapSet.new())
    |> MapSet.delete(guard)
    |> MapSet.size()
  end

  def part2(grid) do
    {grid, guard} = find_guard(grid)

    move(grid, guard, :up, MapSet.new())
    |> Task.async_stream(fn coord ->
      coord != guard && floor?(grid, coord) &&
        check_loop(add_wall(grid, coord), guard, :up, MapSet.new())
    end)
    |> Enum.count(fn {:ok, val} -> val end)
  end

  defp move(grid, guard_position, facing, seen) do
    if !in_grid?(grid, guard_position) do
      seen
    else
      {next_pos, next_facing} = move_forward_or_turn(grid, guard_position, facing)
      move(grid, next_pos, next_facing, MapSet.put(seen, next_pos))
    end
  end

  defp check_loop(grid, guard_position, facing, seen) do
    if !in_grid?(grid, guard_position) do
      false
    else
      {next_pos, next_facing} = move_forward_or_turn(grid, guard_position, facing)

      if MapSet.member?(seen, {next_pos, next_facing}) do
        true
      else
        check_loop(grid, next_pos, next_facing, MapSet.put(seen, {next_pos, next_facing}))
      end
    end
  end

  def parse_input(input) do
    Grid.new(input)
  end

  defp move_forward_or_turn(grid, position, facing) do
    next_position = forward(position, facing)

    if wall?(grid, next_position) do
      move_forward_or_turn(grid, position, turn_right(facing))
    else
      {next_position, facing}
    end
  end

  defp forward({row, col}, :up), do: {row - 1, col}
  defp forward({row, col}, :down), do: {row + 1, col}
  defp forward({row, col}, :left), do: {row, col - 1}
  defp forward({row, col}, :right), do: {row, col + 1}

  defp turn_right(:up), do: :right
  defp turn_right(:right), do: :down
  defp turn_right(:down), do: :left
  defp turn_right(:left), do: :up

  defp find_guard(grid) do
    guard =
      Enum.find(grid, fn {_coord, key} -> key == "^" end)
      |> elem(0)

    {Map.put(grid, guard, "."), guard}
  end

  defp wall?(grid, position), do: Map.get(grid, position) == "#"
  defp floor?(grid, position), do: Map.get(grid, position) == "."
  defp in_grid?(grid, position), do: Map.get(grid, position) != nil
  defp add_wall(grid, position), do: Map.put(grid, position, "#")

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
