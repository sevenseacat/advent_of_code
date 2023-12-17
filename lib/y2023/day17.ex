defmodule Y2023.Day17 do
  use Advent.Day, no: 17

  alias Advent.Grid

  def part1(grid) do
    find_best_path(grid, {1, 1})
  end

  # @doc """
  # iex> Day17.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp find_best_path(grid, {row, col}) do
    PriorityQueue.new()
    |> add_to_queue([[{row, col, nil, 0}]])
    |> search(grid, Grid.size(grid), MapSet.new())
  end

  defp add_to_queue(queue, states) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, state, elem(hd(state), 3))
    end)
  end

  defp search(queue, grid, destination, cache) do
    do_search(PriorityQueue.pop(queue), grid, destination, cache)
  end

  defp do_search({:empty, _queue}, _grid, _destination, _cache) do
    raise("No path found")
  end

  defp do_search(
         {{:value, [{row, col, _direction, count} | _rest]}, _queue},
         _grid,
         {row, col},
         _cache
       ) do
    # Winner winner chicken dinner.
    count
  end

  defp do_search({{:value, path}, queue}, grid, destination, cache) do
    if MapSet.member?(cache, cache_key(path)) do
      # Been here before at a lower heat loss value, ignore
      search(queue, grid, destination, cache)
    else
      cache = MapSet.put(cache, cache_key(path))

      queue
      |> add_to_queue(valid_moves(path, grid))
      |> search(grid, destination, cache)
    end
  end

  defp valid_moves([{row, col, direction, value} | _rest] = path, grid) do
    [{row - 1, col, :up}, {row + 1, col, :down}, {row, col - 1, :left}, {row, col + 1, :right}]
    |> Enum.filter(&in_grid?(grid, &1))
    |> Enum.reject(&backwards?(direction, &1))
    |> Enum.reject(&too_far_straight?(path, &1))
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

  defp too_far_straight?([{_, _, dir, _}, {_, _, dir, _}, {_, _, dir, _} | _rest], {_, _, dir}) do
    true
  end

  defp too_far_straight?(_, _), do: false

  def parse_input(input) do
    input
    |> Grid.new()
    |> Enum.map(fn {a, b} -> {a, String.to_integer(b)} end)
    |> Enum.into(%{})
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
