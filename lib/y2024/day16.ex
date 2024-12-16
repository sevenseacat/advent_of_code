defmodule Y2024.Day16 do
  use Advent.Day, no: 16

  alias Advent.PathGrid

  def part1(path_grid) do
    from = Enum.find(path_grid.units, &(&1.identifier == "S")).position
    to = Enum.find(path_grid.units, &(&1.identifier == "E")).position

    {_path, score} = find_lowest_score(path_grid.graph, from, to)
    score
  end

  # @doc """
  # iex> Day16.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp find_lowest_score(graph, from, to) do
    queue = queue_next_states(PriorityQueue.new(), {from, :east, [{from, :east}], 0}, graph)
    do_search(PriorityQueue.pop(queue), graph, to, MapSet.new([{from, :east}]))
  end

  defp queue_next_states(queue, {coord, facing, path, score}, graph) do
    moves = next_moves(graph, {coord, facing})

    Enum.reduce(moves, queue, fn {coord, facing, added_score}, queue ->
      PriorityQueue.push(
        queue,
        {coord, facing, [{coord, facing} | path], score + added_score},
        score + added_score
      )
    end)
  end

  defp next_moves(graph, {{row1, col1}, facing}) do
    [{{0, -1}, :west}, {{0, 1}, :east}, {{-1, 0}, :north}, {{1, 0}, :south}]
    |> Enum.map(fn {{row2, col2}, dir} ->
      {{row1 + row2, col1 + col2}, dir, if(dir == facing, do: 1, else: 1001)}
    end)
    |> Enum.filter(fn {coord, _dir, _score} -> PathGrid.floor?(graph, coord) end)
  end

  defp do_search({:empty, _queue}, _graph, _to, _seen), do: raise("No winning states!")

  defp do_search({{:value, {coord, facing, path, score}}, queue}, graph, to, seen) do
    if coord == to do
      {path, score}
    else
      if MapSet.member?(seen, {coord, facing}) do
        do_search(PriorityQueue.pop(queue), graph, to, seen)
      else
        queue = queue_next_states(queue, {coord, facing, path, score}, graph)
        do_search(PriorityQueue.pop(queue), graph, to, MapSet.put(seen, {coord, facing}))
      end
    end
  end

  def parse_input(input) do
    PathGrid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
