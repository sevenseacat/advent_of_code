defmodule Y2023.Day08 do
  use Advent.Day, no: 08

  # 17288 - too high
  def part1(input) do
    traverse("AAA", "ZZZ", input.network, {input.directions, []}, [])
  end

  defp traverse(current, current, _, _, path), do: Enum.reverse(path)

  defp traverse(current, destination, network, directions, path) do
    {move, directions} = next_move(directions)

    network
    |> Map.fetch!(current)
    |> Map.fetch!(move)
    |> traverse(destination, network, directions, [current | path])
  end

  defp next_move({[], list}), do: next_move({Enum.reverse(list), []})
  defp next_move({[h | t], list}), do: {h, {t, [h | list]}}

  # @doc """
  # iex> Day08.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    [directions, network] = String.split(input, "\n\n", trim: true)

    network =
      for node <- String.split(network, "\n", trim: true), into: %{} do
        <<name::binary-3, " = (", <<left::binary-3>>, ", ", <<right::binary-3>>, ")">> = node
        {name, %{"L" => left, "R" => right}}
      end

    %{directions: String.graphemes(directions), network: network}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> length()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
