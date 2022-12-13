defmodule Y2022.Day13 do
  use Advent.Day, no: 13

  def part1(input) do
    input
    |> Enum.with_index()
    |> Enum.filter(fn {{left, right}, _index} -> correct_order?(left, right) end)
    |> Enum.map(fn {_pair, index} -> index + 1 end)
    |> Enum.sum()
  end

  def part2(input) do
    decoders = [[[2]], [[6]]]

    (decoders ++ Enum.flat_map(input, &Tuple.to_list/1))
    |> Enum.sort(&correct_order?/2)
    |> Enum.with_index()
    |> Enum.filter(fn {row, _index} -> row in decoders end)
    |> Enum.map(fn {_row, index} -> index + 1 end)
    |> Enum.product()
  end

  def correct_order?([left | l], [right | r]) when is_integer(left) and is_integer(right) do
    cond do
      left < right -> true
      left > right -> false
      left == right -> correct_order?(l, r)
    end
  end

  def correct_order?([left | l], [right | r]) when is_list(left) and is_list(right) do
    if left == right do
      correct_order?(l, r)
    else
      correct_order?(left, right)
    end
  end

  def correct_order?([], right) when is_list(right), do: true
  def correct_order?(left, []) when is_list(left), do: false

  def correct_order?([left | l], right) when is_integer(left) do
    correct_order?([[left] | l], right)
  end

  def correct_order?(left, [right | r]) when is_integer(right) do
    correct_order?(left, [[right] | r])
  end

  @doc """
  iex> Day13.parse_input("[1,1,3,1,1]\\n[1,1,5,1,1]\\n\\n[[1],[2,3,4]]\\n[[1],4]")
  [{[1,1,3,1,1], [1,1,5,1,1]}, {[[1],[2,3,4]], [[1],4]}]
  """
  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pair/1)
  end

  defp parse_pair(pair) do
    pair
    |> String.split("\n", trim: true)
    |> Enum.map(fn string -> string |> Code.eval_string() |> elem(0) end)
    |> List.to_tuple()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
