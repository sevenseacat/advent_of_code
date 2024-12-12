defmodule Y2024.Day12 do
  use Advent.Day, no: 12

  def part1(grid) do
    grid
    |> find_regions()
    |> find_borders(grid)
    |> Enum.map(fn {plot, regions} ->
      clean_regions =
        regions
        |> Enum.map(fn region ->
          %{area: MapSet.size(region.coords), border: region.border}
        end)

      {plot, clean_regions}
    end)
    |> Map.new()
  end

  # @doc """
  # iex> Day12.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    Advent.Grid.new(input)
  end

  def find_regions(grid) do
    grid
    |> Enum.group_by(fn {_coord, plot} -> plot end)
    |> Task.async_stream(fn {plot, list} ->
      coords = Enum.map(list, fn {coord, _plot} -> coord end)
      {plot, group_regions(coords) |> Enum.map(fn coords -> %{coords: coords} end)}
    end)
    |> Enum.reduce(%{}, fn {:ok, {plot, regions}}, acc -> Map.put(acc, plot, regions) end)
  end

  # There's probably a better way to do this - grabbing a coord and using a bfs to find all connecting
  # coords to it, one by one. When all connecting coords are found, start a new region search with
  # what's left
  defp group_regions(coords), do: do_group_regions([hd(coords)], tl(coords), [MapSet.new()])

  defp do_group_regions([], [], list), do: list

  defp do_group_regions([], coords, list),
    do: do_group_regions([hd(coords)], tl(coords), [MapSet.new() | list])

  defp do_group_regions([{row, col} | coords], rest, list) do
    {adjacent, not_adjacent} =
      Enum.split_with(rest, fn rest ->
        Enum.any?([{0, -1}, {0, 1}, {-1, 0}, {1, 0}], fn {offset_row, offset_col} ->
          rest == {row + offset_row, col + offset_col}
        end)
      end)

    do_group_regions(adjacent ++ coords, not_adjacent, [
      MapSet.put(hd(list), {row, col}) | tl(list)
    ])
  end

  def find_borders(regions, grid) do
    regions
    |> Enum.map(fn {plot, plot_regions} ->
      {plot,
       Enum.map(plot_regions, fn plot_region ->
         border =
           Enum.reduce(plot_region.coords, 0, fn coord, acc ->
             acc + find_new_borders(grid, coord, plot)
           end)

         Map.put(plot_region, :border, border)
       end)}
    end)
    |> Map.new()
  end

  defp find_new_borders(map, {row, col}, plot) do
    [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
    |> Enum.count(fn {offset_row, offset_col} ->
      Map.get(map, {row + offset_row, col + offset_col}) != plot
    end)
  end

  defp to_number(map) do
    Enum.reduce(map, 0, fn {_plot, map}, acc ->
      Enum.reduce(map, acc, fn %{area: area, border: border}, acc ->
        acc + border * area
      end)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> to_number()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
