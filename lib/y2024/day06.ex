defmodule Y2024.Day06 do
  use Advent.Day, no: 06
  alias Advent.PathGrid

  def part1(%PathGrid{graph: grid, units: [guard]}) do
    been_at =
      move(grid, guard.position, :up, MapSet.new([guard.position]))
      |> MapSet.size()

    # Don't include the starting position
    been_at - 1
  end

  # @doc """
  # iex> Day06.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp move(grid, guard_position, facing, seen) do
    if !PathGrid.in_graph?(grid, guard_position) do
      seen
    else
      {next_pos, next_facing} = move_forward_or_turn(grid, guard_position, facing)
      # PathGrid.display(grid, [], seen)
      move(grid, next_pos, next_facing, MapSet.put(seen, next_pos))
    end
  end

  def parse_input(input) do
    PathGrid.new(input)
  end

  defp move_forward_or_turn(grid, position, facing) do
    next_position = forward(position, facing)

    if PathGrid.wall?(grid, next_position) do
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

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
