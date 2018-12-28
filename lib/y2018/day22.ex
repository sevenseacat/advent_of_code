defmodule Y2018.Day22 do
  use Advent.Day, no: 22

  @depth 3558
  @target {15, 740}

  @doc """
  iex> Day22.part1({10, 10}, 510)
  114
  """
  def part1(target \\ @target, depth \\ @depth) do
    build_geological_level_table(target)
    |> convert_to_erosion_levels(depth)
    |> Enum.reduce(0, fn {_coord, level}, sum ->
      sum + rem(level, 3)
    end)
  end

  def build_geological_level_table({max_x, max_y}) do
    # This is just a summed-area table with a few extra conditions.
    Enum.reduce(0..max_x, %{}, fn x, x_acc ->
      Enum.reduce(0..max_y, x_acc, fn y, acc ->
        Map.put(acc, {x, y}, geo_level({x, y}, {max_x, max_y}, acc))
      end)
    end)
  end

  def convert_to_erosion_levels(map, depth) do
    Enum.reduce(map, map, fn {coord, level}, map ->
      Map.put(map, coord, rem(level + depth, 20183))
    end)
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

  defp geo_level({0, 0}, _target, _map), do: 0
  defp geo_level({x, 0}, _target, _map), do: x * 16807
  defp geo_level({0, y}, _target, _map), do: y * 48271
  defp geo_level({x, y}, {x, y}, _map), do: 0

  defp geo_level({x, y}, _target, map) do
    Map.get(map, {x - 1, y}) * Map.get(map, {x, y - 1})
  end

  defp get_symbol(0), do: "."
  defp get_symbol(1), do: "="
  defp get_symbol(2), do: "|"
end
