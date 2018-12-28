defmodule Y2018.Day22 do
  use Advent.Day, no: 22

  @depth 3558
  @target {15, 740}

  @magic_x 16807
  @magic_y 48271
  @magic_erosion 20183

  @doc """
  iex> Day22.part1({10, 10}, 510)
  114
  """
  def part1(target \\ @target, depth \\ @depth) do
    build_erosion_level_table(target, depth)
    |> Enum.reduce(0, fn {_coord, level}, sum ->
      sum + rem(level, 3)
    end)
  end

  def build_erosion_level_table({max_x, max_y}, depth) do
    # This is just a summed-area table with a few extra conditions.
    Enum.reduce(0..max_x, %{}, fn x, x_acc ->
      Enum.reduce(0..max_y, x_acc, fn y, acc ->
        level =
          geo_level({x, y}, {max_x, max_y}, acc)
          |> to_erosion_level(depth)

        Map.put(acc, {x, y}, level)
      end)
    end)
  end

  def to_erosion_level(val, depth), do: rem(val + depth, @magic_erosion)

  defp geo_level({0, 0}, _target, _map), do: 0
  defp geo_level({x, y}, {x, y}, __map), do: 0
  defp geo_level({x, 0}, _target, _map), do: x * @magic_x
  defp geo_level({0, y}, _target, _map), do: y * @magic_y

  defp geo_level({x, y}, _target, map) do
    # Numbers are going to get way too big if we use them natively
    # Because we literally only care about the remainders of dividing a bunch of numbers,
    # we can divide by the lowest common multiple of all of the things - the remainders
    # will still be the same
    lcm = @magic_x * @magic_y * @magic_erosion
    rem(Map.get(map, {x - 1, y}) * Map.get(map, {x, y - 1}), lcm)
  end

  def display_grid(map, {max_x, max_y}) do
    Enum.each(0..max_y, fn y ->
      Enum.reduce(0..max_x, [], fn x, acc ->
        [get_symbol(rem(Map.get(map, {x, y}), 3)) | acc]
      end)
      |> Enum.reverse()
      |> List.to_string()
      |> IO.puts()
    end)

    map
  end

  defp get_symbol(0), do: "."
  defp get_symbol(1), do: "="
  defp get_symbol(2), do: "|"

  def part1_verify, do: part1()
end
