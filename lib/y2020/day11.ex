defmodule Y2020.Day11 do
  use Advent.Day, no: 11

  def part1(input), do: do_part1(input, 0)

  defp do_part1(input, round_no) do
    result = run_round(input)

    if result == input do
      {Enum.count(result, fn {_, val} -> val == :occupied end), round_no}
    else
      do_part1(result, round_no + 1)
    end
  end

  def run_round(input) do
    Enum.reduce(input, %{}, fn val, acc -> update_seat(val, input, acc) end)
  end

  defp update_seat({position, current}, previous, acc) do
    new_status =
      case {current, count_occupied_neighbours(position, previous)} do
        {:empty, 0} -> :occupied
        {:occupied, count} when count >= 4 -> :empty
        _ -> current
      end

    Map.put(acc, position, new_status)
  end

  defp count_occupied_neighbours(position, input) do
    position
    |> neighbouring_seats(input)
    |> Enum.count(fn seat -> seat == :occupied end)
  end

  defp neighbouring_seats({row, col}, input) do
    [
      {row - 1, col},
      {row - 1, col - 1},
      {row, col - 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1},
      {row, col + 1},
      {row - 1, col + 1}
    ]
    |> Enum.map(fn pos -> Map.get(input, pos, :empty) end)
  end

  @doc """
  iex> Day11.part2(:parsed_input)
  :ok
  """
  def part2(_input) do
    :ok
  end

  @doc """
  iex> Day11.parse_input("L.LL.LL.LL\\nLLLLLLL.LL\\n")
  %{{0,0} => :empty, {0,2} => :empty, {0,3} => :empty, {0,5} => :empty, {0,6} => :empty,
    {0,8} => :empty, {0,9} => :empty, {1,0} => :empty, {1,1} => :empty, {1,2} => :empty,
    {1,3} => :empty, {1,4} => :empty, {1,5} => :empty, {1,6} => :empty, {1,8} => :empty,
    {1,9} => :empty}
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_row/2)
  end

  defp parse_row({row, row_no}, acc) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {col, col_no}, acc ->
      parse_col(col, row_no, col_no, acc)
    end)
  end

  defp parse_col(".", _, _, map), do: map
  defp parse_col("L", row, col, map), do: Map.put(map, {row, col}, :empty)
  defp parse_col("#", row, col, map), do: Map.put(map, {row, col}, :occupied)

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(0)
end
