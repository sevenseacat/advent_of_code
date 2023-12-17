defmodule Y2023.Day17 do
  use Advent.Day, no: 17

  alias Advent.Grid

  def part1(grid) do
    find_best_path(grid, {1, 1}, 0..3)
  end

  def part2(grid) do
    find_best_path(grid, {1, 1}, 4..10)
  end

  defp find_best_path(grid, {row, col}, length_range) do
    PriorityQueue.new()
    |> add_to_queue([[{row, col, :down, 0}]])
    |> add_to_queue([[{row, col, :right, 0}]])
    |> search(grid, Grid.size(grid), MapSet.new(), length_range)
  end

  defp add_to_queue(queue, states) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, state, elem(hd(state), 3))
    end)
  end

  defp search(queue, grid, destination, cache, length_range) do
    do_search(PriorityQueue.pop(queue), grid, destination, cache, length_range)
  end

  defp do_search({:empty, _queue}, _grid, _destination, _cache, _straight_line_length) do
    raise("No path found")
  end

  defp do_search({{:value, path}, queue}, grid, destination, cache, length_range) do
    {row, col, _, count} = hd(path)

    if {row, col} == destination && passes_final_straight_check?(path, length_range) do
      # Winner winner chicken dinner.
      # Grid.display(grid, Enum.map(path, fn {row, col, _, _} -> {row, col} end))
      count
    else
      cache_key = cache_key(path)

      if MapSet.member?(cache, cache_key) do
        # Been here before at a lower heat loss value, ignore
        search(queue, grid, destination, cache, length_range)
      else
        cache = MapSet.put(cache, cache_key)

        queue
        |> add_to_queue(valid_moves(path, grid, length_range))
        |> search(grid, destination, cache, length_range)
      end
    end
  end

  defp valid_moves([{row, col, direction, value} | _rest] = path, grid, length_range) do
    [{row - 1, col, :up}, {row + 1, col, :down}, {row, col - 1, :left}, {row, col + 1, :right}]
    |> Enum.filter(&in_grid?(grid, &1))
    |> Enum.reject(&backwards?(direction, &1))
    |> Enum.filter(&passes_straight_check?(path, &1, length_range))
    |> Enum.map(fn {row, col, dir} ->
      [{row, col, dir, value + Map.fetch!(grid, {row, col})} | path]
    end)
  end

  defp cache_key([{row, col, direction, _} | _rest] = path) do
    # The cache key has to include the last three directions
    # Something going |  may give a different result to --
    #                 |-                                 |
    # even with the same current value, due to the straight run length
    # limitation
    next_cache = Enum.take_while(path, fn {_, _, dir, _} -> dir == direction end) |> length()
    {{row, col, direction}, next_cache}
  end

  defp in_grid?(grid, {row, col, _dir}), do: Map.has_key?(grid, {row, col})

  defp backwards?(from, {_, _, to}) do
    {from, to} in [{:left, :right}, {:right, :left}, {:up, :down}, {:down, :up}]
  end

  defp passes_straight_check?(
         [{_, _, from_dir, _} | _rest] = path,
         {_, _, to_dir},
         length_range
       ) do
    _min..max = length_range

    straight = straight_line_length(path)

    cond do
      from_dir == to_dir -> straight < max
      from_dir != to_dir -> straight in length_range
    end
  end

  defp passes_final_straight_check?(path, length_range) do
    straight_line_length(path) in length_range
  end

  defp straight_line_length(path) do
    {_, _, direction, _} = hd(path)

    path
    |> Enum.take_while(fn {_, _, dir, _} -> dir == direction end)
    |> length
  end

  @spec parse_input(binary()) :: any()
  def parse_input(input) do
    input
    |> Grid.new()
    |> Enum.map(fn {a, b} -> {a, String.to_integer(b)} end)
    |> Enum.into(%{})
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
