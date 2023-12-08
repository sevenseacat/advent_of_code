defmodule Y2023.Day08 do
  use Advent.Day, no: 08

  # 17288 - too high
  def part1(input) do
    traverse("AAA", &(&1 == "ZZZ"), input.network, {input.directions, []}, 0)
  end

  def part2(input) do
    input.network
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Task.async_stream(fn node ->
      traverse(node, &String.ends_with?(&1, "Z"), input.network, {input.directions, []}, 0)
    end)
    |> Enum.map(fn {:ok, val} -> val end)
    |> Advent.lowest_common_multiple()
  end

  defp traverse(current, destination_fun, network, directions, count) do
    if destination_fun.(current) do
      count
    else
      {move, directions} = next_move(directions)

      network
      |> Map.fetch!(current)
      |> Map.fetch!(move)
      |> traverse(destination_fun, network, directions, count + 1)
    end
  end

  defp next_move({[], list}), do: next_move({Enum.reverse(list), []})
  defp next_move({[h | t], list}), do: {h, {t, [h | list]}}

  def parse_input(input) do
    [directions, network] = String.split(input, "\n\n", trim: true)

    network =
      for node <- String.split(network, "\n", trim: true), into: %{} do
        <<name::binary-3, " = (", <<left::binary-3>>, ", ", <<right::binary-3>>, ")">> = node
        {name, %{"L" => left, "R" => right}}
      end

    %{directions: String.graphemes(directions), network: network}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
