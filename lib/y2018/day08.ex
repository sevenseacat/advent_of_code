defmodule Y2018.Day08 do
  use Advent.Day, no: 8

  @doc """
  iex> Day08.part1("0 3 0 1 2")
  3

  iex> Day08.part1("1 3 0 1 55 0 1 2")
  58

  iex> Day08.part1("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
  138
  """
  def part1(input) do
    input
    |> parse_input
    |> sum_metadata
  end

  @doc """
  iex> Day08.part2("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
  66
  """
  def part2(input) do
    input
    |> parse_input
    |> sum_value
  end

  defp sum_metadata(%{metadata: metadata, children: children}) do
    Enum.sum(Enum.map(children, &sum_metadata/1)) + Enum.sum(metadata)
  end

  defp sum_value(%{children: [], metadata: metadata}) do
    Enum.sum(metadata)
  end

  defp sum_value(%{children: children, metadata: metadata}) do
    Enum.reduce(metadata, 0, fn x, acc ->
      acc + get_child_metadata_value(x - 1, children)
    end)
  end

  defp get_child_metadata_value(x, children) do
    case Enum.at(children, x) do
      nil -> 0
      child -> sum_value(child)
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> read_nodes([])
    |> Enum.at(1)
    |> hd
  end

  defp read_nodes([], acc), do: acc

  defp read_nodes(input, acc) do
    {node, rest} = read_node(input)
    [rest, [node | acc]]
  end

  defp read_node([children_count, metadata_count | rest]) do
    {rest, children} =
      if children_count > 0 do
        1..children_count
        |> Enum.to_list()
        |> Enum.reduce({rest, []}, fn _index, {new_rest, children} ->
          {node, rest} = read_node(new_rest)
          {rest, [node | children]}
        end)
      else
        {rest, []}
      end

    {metadata, rest} = Enum.split(rest, metadata_count)
    {%{children: Enum.reverse(children), metadata: metadata}, rest}
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
