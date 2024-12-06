defmodule Y2024.Day06 do
  use Advent.Day, no: 06
  alias Advent.Grid

  def part1(%{walls: walls, guard: guard, size: size}) do
    move(walls, guard, :up, size, MapSet.new())
    |> MapSet.size()
    # Don't include the last out-of-grid step
    |> Kernel.-(1)
  end

  def part2(%{walls: walls, guard: guard, size: size}) do
    move(walls, guard, :up, size, MapSet.new())
    |> Task.async_stream(fn coord ->
      coord != guard && !wall?(walls, coord) &&
        check_loop(add_wall(walls, coord), guard, :up, size, MapSet.new())
    end)
    |> Enum.count(fn {:ok, val} -> val end)
  end

  defp move(walls, guard_position, facing, size, seen) do
    if out_of_grid?(size, guard_position) do
      seen
    else
      {next_pos, next_facing} = move_forward_or_turn(walls, guard_position, facing)
      move(walls, next_pos, next_facing, size, MapSet.put(seen, next_pos))
    end
  end

  defp check_loop(walls, guard_position, facing, size, seen) do
    if out_of_grid?(size, guard_position) do
      false
    else
      {next_pos, next_facing} = move_forward_or_turn(walls, guard_position, facing)

      if MapSet.member?(seen, {next_pos, next_facing}) do
        true
      else
        check_loop(walls, next_pos, next_facing, size, MapSet.put(seen, {next_pos, next_facing}))
      end
    end
  end

  def parse_input(input) do
    grid = Grid.new(input)
    guard = find_guard(grid)

    walls =
      grid
      |> Enum.filter(fn {_coord, val} -> val == "#" end)
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    %{size: Grid.size(grid), walls: walls, guard: guard}
  end

  defp move_forward_or_turn(walls, position, facing) do
    next_position = forward(position, facing)

    if wall?(walls, next_position) do
      move_forward_or_turn(walls, position, turn_right(facing))
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
    Enum.find(grid, fn {_coord, key} -> key == "^" end)
    |> elem(0)
  end

  defp wall?(walls, position), do: MapSet.member?(walls, position)
  defp add_wall(walls, position), do: MapSet.put(walls, position)

  defp out_of_grid?({max_row, max_col}, {row, col}) do
    row < 0 || row > max_row || col < 0 || col > max_col
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
