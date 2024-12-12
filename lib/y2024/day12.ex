defmodule Y2024.Day12 do
  use Advent.Day, no: 12

  def part1(grid) do
    grid
    |> find_regions()
    |> find_borders(grid)
    |> Enum.map(fn {plot, regions} ->
      {plot,
       Enum.map(regions, fn region ->
         %{area: MapSet.size(region.coords), border: MapSet.size(region.borders)}
       end)}
    end)
    |> Map.new()
  end

  def part2(grid) do
    grid
    |> find_regions()
    |> find_borders(grid)
    |> find_sides()
    |> Enum.map(fn {plot, regions} ->
      {plot,
       Enum.map(regions, fn region ->
         %{area: MapSet.size(region.coords), sides: length(region.sides)}
       end)}
    end)
    |> Map.new()
  end

  def parse_input(input) do
    Advent.Grid.new(input)
  end

  def find_regions(grid) do
    grid
    |> Enum.group_by(fn {_coord, plot} -> plot end)
    |> Task.async_stream(fn {plot, list} ->
      coords = Enum.map(list, fn {coord, _plot} -> coord end)

      {plot,
       group_connecting(coords)
       |> Enum.map(fn coords -> %{coords: coords} end)}
    end)
    |> Enum.reduce(%{}, fn {:ok, {plot, regions}}, acc -> Map.put(acc, plot, regions) end)
  end

  def find_sides(map) do
    map
    |> Task.async_stream(fn {plot, list} ->
      {plot,
       Enum.map(list, fn region ->
         sides =
           region.borders
           |> Enum.group_by(fn {_, dir} -> dir end)
           |> Enum.flat_map(fn {_, list} ->
             list
             |> Enum.map(fn {coord, _} -> coord end)
             |> group_connecting()
           end)

         Map.put(region, :sides, sides)
       end)}
    end)
    |> Enum.reduce(%{}, fn {:ok, {plot, regions}}, acc -> Map.put(acc, plot, regions) end)
  end

  # There's probably a better way to do this - grabbing a coord and using a bfs to find all connecting
  # coords to it, one by one. When all connecting coords are found, start a new search with
  # what's left
  defp group_connecting(coords),
    do: do_group_connecting([hd(coords)], tl(coords), [MapSet.new()])

  defp do_group_connecting([], [], list), do: list

  defp do_group_connecting([], coords, list) do
    do_group_connecting([hd(coords)], tl(coords), [MapSet.new() | list])
  end

  defp do_group_connecting([{row, col} | coords], rest, list) do
    {adjacent, not_adjacent} =
      Enum.split_with(rest, fn rest ->
        Enum.any?([{0, -1}, {0, 1}, {-1, 0}, {1, 0}], fn {offset_row, offset_col} ->
          rest == {row + offset_row, col + offset_col}
        end)
      end)

    do_group_connecting(adjacent ++ coords, not_adjacent, [
      MapSet.put(hd(list), {row, col}) | tl(list)
    ])
  end

  def find_borders(regions, grid) do
    regions
    |> Enum.map(fn {plot, plot_regions} ->
      {plot,
       Enum.map(plot_regions, fn plot_region ->
         borders =
           Enum.reduce(plot_region.coords, MapSet.new(), fn coord, acc ->
             grid
             |> find_new_borders(coord, plot)
             |> Enum.reduce(acc, fn coord, acc -> MapSet.put(acc, coord) end)
           end)

         Map.put(plot_region, :borders, borders)
       end)}
    end)
    |> Map.new()
  end

  defp find_new_borders(map, {row, col}, plot) do
    [
      {{0, -1}, :left},
      {{0, 1}, :right},
      {{-1, 0}, :up},
      {{1, 0}, :down}
    ]
    |> Enum.filter(fn {{offset_row, offset_col}, _} ->
      Map.get(map, {row + offset_row, col + offset_col}) != plot
    end)
    |> Enum.map(fn {{offset_row, offset_col}, dir} ->
      {{row + offset_row, col + offset_col}, dir}
    end)
  end

  defp calculate_cost(map, [one, two]) do
    Enum.reduce(map, 0, fn {_plot, map}, acc ->
      Enum.reduce(map, acc, fn record, acc ->
        acc + Map.fetch!(record, one) * Map.fetch!(record, two)
      end)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> calculate_cost([:border, :area])
  def part2_verify, do: input() |> parse_input() |> part2() |> calculate_cost([:sides, :area])
end
