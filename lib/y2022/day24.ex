defmodule Y2022.Day24 do
  use Advent.Day, no: 24
  alias Advent.Grid

  def part1(input) do
    {{max_row, max_col} = max_coord, _val} = Enum.max_by(input, fn {coord, _val} -> coord end)

    get_shortest_path(input, max_coord, {{1, 2}, {max_row, max_col - 1}})
    |> elem(0)
  end

  def part2(input) do
    {{max_row, max_col} = max_coord, _val} = Enum.max_by(input, fn {coord, _val} -> coord end)

    from = {1, 2}
    to = {max_row, max_col - 1}
    {lap1, blizzards} = get_shortest_path(input, max_coord, {from, to})
    {lap2, blizzards} = get_shortest_path(blizzards, max_coord, {to, from})
    {lap3, _blizzards} = get_shortest_path(blizzards, max_coord, {from, to})

    lap1 + lap2 + lap3
  end

  defp get_shortest_path(input, max_coord, {source, destination}) do
    {moves, blizzard_paths} = legal_moves({%{0 => input}, max_coord}, source, 1)

    search(
      add_to_queue(PriorityQueue.new(), {moves, 1}),
      destination,
      MapSet.new(),
      blizzard_paths
    )
  end

  defp add_to_queue(queue, {states, turn}) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, {state, turn}, turn)
    end)
  end

  defp search(queue, destination, cache, blizzard_paths) do
    do_search(PriorityQueue.pop(queue), destination, cache, blizzard_paths)
  end

  defp do_search({:empty, _queue}, _destination, _cache, _blizzard_paths) do
    raise("No winning states!")
  end

  defp do_search({{:value, {position, turn}}, _queue}, position, _cache, {blizzard_paths, _}) do
    # Winner winner chicken dinner.
    {turn, Map.fetch!(blizzard_paths, turn)}
  end

  defp do_search({{:value, {position, turn}}, queue}, destination, cache, blizzard_paths) do
    hash = hash(position, turn, blizzard_paths)

    if MapSet.member?(cache, hash) do
      # Seen a better version of this state, scrap this one
      search(queue, destination, cache, blizzard_paths)
    else
      # Calculate legal moves, record seen, etc.
      {moves, blizzard_paths} = legal_moves(blizzard_paths, position, turn + 1)

      search(
        add_to_queue(queue, {moves, turn + 1}),
        destination,
        MapSet.put(cache, hash),
        blizzard_paths
      )
    end
  end

  defp hash(position, turn, {blizzard_paths, _max_coord}) do
    :erlang.phash2({position, Map.fetch!(blizzard_paths, turn)})
  end

  defp legal_moves({blizzard_paths, max_coord}, {row, col}, turn) do
    blizzard_paths =
      Map.put_new_lazy(blizzard_paths, turn, fn ->
        calculate_blizzard_movements(Map.fetch!(blizzard_paths, turn - 1), max_coord)
      end)

    blizzards = Map.fetch!(blizzard_paths, turn)

    moves =
      [{row - 1, col}, {row + 1, col}, {row, col + 1}, {row, col - 1}, {row, col}]
      |> Enum.filter(fn coord -> Map.get(blizzards, coord) == ["."] end)

    {moves, {blizzard_paths, max_coord}}
  end

  defp calculate_blizzard_movements(state, {max_row, max_col} = max_coord) do
    state =
      Enum.reduce(state, %{}, fn {{row, col}, types}, acc ->
        Enum.reduce(types, acc, fn type, acc ->
          if type == "." do
            acc
          else
            new_coord =
              case type do
                ">" -> maybe_wrap({row, col + 1}, max_coord)
                "<" -> maybe_wrap({row, col - 1}, max_coord)
                "^" -> maybe_wrap({row - 1, col}, max_coord)
                "v" -> maybe_wrap({row + 1, col}, max_coord)
                _ -> {row, col}
              end

            Map.update(acc, new_coord, [type], &[type | &1])
          end
        end)
      end)

    for(row <- 1..max_row, col <- 1..max_col, do: {row, col})
    |> Enum.reduce(state, fn coord, acc -> Map.put_new(acc, coord, ["."]) end)
  end

  defp maybe_wrap({row, col}, {max_row, max_col}) do
    cond do
      row <= 1 && col != 2 ->
        if col == max_col, do: {max_row, col}, else: {max_row - 1, col}

      row >= max_row && col != max_col ->
        if col == 2, do: {1, 2}, else: {2, col}

      col <= 1 ->
        {row, max_col - 1}

      col >= max_col ->
        {row, 2}

      true ->
        {row, col}
    end
  end

  def parse_input(input) do
    Grid.new(input)
    |> Enum.map(fn {coord, val} -> {coord, [val]} end)
    |> Map.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
