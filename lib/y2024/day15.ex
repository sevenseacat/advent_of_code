defmodule Y2024.Day15 do
  use Advent.Day, no: 15

  alias Advent.PathGrid

  def part1(input) do
    input
    |> run_movements()
    |> calculate_score()
  end

  # @doc """
  # iex> Day15.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def run_movements({grid, movements}) do
    {guard, rocks} = split_units(grid.units)
    do_run_movements(grid.graph, guard, rocks, movements)
  end

  defp do_run_movements(_graph, guard, rocks, []), do: {guard, rocks}

  defp do_run_movements(graph, guard, rocks, [move | movements]) do
    {guard, rocks} = move(guard, rocks, move, graph)
    do_run_movements(graph, guard, rocks, movements)
  end

  defp move({grow, gcol} = guard, rocks, move, graph) do
    {orow, ocol} = offset = to_offset(move)
    destination = {grow + orow, gcol + ocol}

    cond do
      PathGrid.wall?(graph, destination) ->
        # Can't move, wall in the way
        {guard, rocks}

      Enum.any?(rocks, &(&1 == destination)) ->
        # Push it real good!
        push(guard, rocks, offset, graph)

      true ->
        # Guard moves, next loop
        {destination, rocks}
    end
  end

  def display(graph, guard, rocks) do
    PathGrid.display(graph, [
      %{position: guard, identifier: "@"} | Enum.map(rocks, &%{identifier: "O", position: &1})
    ])
  end

  defp push({grow, gcol} = guard, rocks, {orow, ocol} = offset, graph) do
    if mult = can_push?(guard, rocks, offset, graph) do
      guard = {grow + orow, gcol + ocol}

      rocks =
        Enum.map(rocks, fn {rrow, rcol} ->
          if {rrow, rcol} == {grow + orow, gcol + ocol} do
            {rrow + mult * orow, rcol + mult * ocol}
          else
            {rrow, rcol}
          end
        end)

      {guard, rocks}
    else
      {guard, rocks}
    end
  end

  # Ensure that there is a free space after the rocks to push to
  defp can_push?({grow, gcol}, rocks, {orow, ocol}, graph) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(nil, fn mult, _ ->
      check_coord = {grow + mult * orow, gcol + mult * ocol}

      cond do
        PathGrid.wall?(graph, check_coord) ->
          {:halt, false}

        Enum.any?(rocks, &(&1 == check_coord)) ->
          {:cont, nil}

        PathGrid.floor?(graph, check_coord) ->
          {:halt, mult - 1}
      end
    end)
  end

  defp split_units(list) do
    groups = Enum.group_by(list, & &1.identifier)
    {hd(groups["@"]).position, Enum.map(groups["O"], & &1.position)}
  end

  defp to_offset("<"), do: {0, -1}
  defp to_offset(">"), do: {0, 1}
  defp to_offset("^"), do: {-1, 0}
  defp to_offset("v"), do: {1, 0}

  defp calculate_score({_guard, rocks}) do
    Enum.reduce(rocks, 0, fn {row, col}, acc ->
      acc + 100 * (row - 1) + col - 1
    end)
  end

  def parse_input(input) do
    [grid, movements] = String.split(input, "\n\n", trim: true)
    {PathGrid.new(grid), String.graphemes(String.replace(movements, "\n", ""))}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
