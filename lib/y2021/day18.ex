defmodule Y2021.Day18 do
  use Advent.Day, no: 18

  def part1(input) do
    input
    |> final_sum()
    |> magnitude()
  end

  def part2(input) do
    input
    |> Advent.permutations(2)
    |> Enum.map(fn pair -> pair |> reduce() |> magnitude() end)
    |> Enum.max()
  end

  def final_sum([one]), do: one

  def final_sum([one, two | rest]) do
    final_sum([reduce([one, two]) | rest])
  end

  defp reduce(num) do
    result = explode(num)
    if num === result, do: split(result), else: reduce(result)
  end

  def explode(num) do
    case maybe_explode(num, 0) do
      {val, _nowhere_to_go} -> val
      val -> val
    end
  end

  defp maybe_explode([left, right], level) when level == 4 do
    {0, {left, right}}
  end

  defp maybe_explode([left, right], level) do
    case {maybe_explode(left, level + 1), maybe_explode(right, level + 1)} do
      {^left, ^right} ->
        [left, right]

      {{val, {move_left, move_right}}, _right} ->
        {[val, add_to_left(right, move_right)], {move_left, nil}}

      {^left, {val, {move_left, move_right}}} ->
        {[add_to_right(left, move_left), val], {nil, move_right}}
    end
  end

  defp maybe_explode(num, _level) when is_integer(num), do: num

  defp add_to_left(val, nil), do: val
  defp add_to_left([left, right], val), do: [add_to_left(left, val), right]
  defp add_to_left(num, val), do: num + val

  defp add_to_right(val, nil), do: val
  defp add_to_right([left, right], val), do: [left, add_to_right(right, val)]
  defp add_to_right(num, val), do: num + val

  defp split(num) do
    result = maybe_split(num)
    if num === result, do: result, else: reduce(result)
  end

  def maybe_split([left, right]) do
    case {maybe_split(left), maybe_split(right)} do
      {^left, ^right} -> [left, right]
      {^left, new_right} -> [left, new_right]
      {new_left, _right} -> [new_left, right]
    end
  end

  def maybe_split(num) when num >= 10, do: [floor(num / 2), ceil(num / 2)]
  def maybe_split(num), do: num

  def magnitude([left, right]), do: 3 * magnitude(left) + 2 * magnitude(right)
  def magnitude(num), do: num

  @doc """
  iex> Day18.parse_input("[1,2]\\n[[1,2],3]\\n[9,[8,7]]\\n[[1,9],[8,5]]\\n")
  [[1,2], [[1,2],3], [9,[8,7]], [[1,9],[8,5]]]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {list, _binding} = Code.eval_string(line)
      list
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
