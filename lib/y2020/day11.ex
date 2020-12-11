defmodule Y2020.Day11 do
  use Advent.Day, no: 11

  def part1(input), do: do_parts(input, 0, 4, &neighbouring_seats/2)

  defp do_parts(input, round_no, max_occupied, neighbour_fn) do
    result = run_round(input, max_occupied, neighbour_fn)

    if result == input do
      {Enum.count(result, fn {_, val} -> val == :occupied end), round_no}
    else
      do_parts(result, round_no + 1, max_occupied, neighbour_fn)
    end
  end

  def run_round(input, max_occupied \\ 4, neighbour_fn \\ &neighbouring_seats/2) do
    Enum.reduce(input, %{}, fn val, acc ->
      update_seat(val, input, acc, max_occupied, neighbour_fn)
    end)
  end

  defp update_seat({position, current}, previous, acc, max_occupied, neighbour_fn) do
    new_status =
      case {current, count_occupied_neighbours(position, previous, neighbour_fn)} do
        {:empty, 0} -> :occupied
        {:occupied, count} when count >= max_occupied -> :empty
        _ -> current
      end

    Map.put(acc, position, new_status)
  end

  defp count_occupied_neighbours(position, input, neighbour_fn) do
    position
    |> neighbour_fn.(input)
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
    |> Enum.map(fn pos -> Map.get(input, pos) end)
  end

  def part2(_input) do
    :ok
  end

  @doc """
  iex> Day11.parse_input("L.LL.LL.LL\\nLLLLLLL.LL\\n")
  %{{0,0} => :empty, {0,1} => :floor, {0,2} => :empty, {0,3} => :empty, {0,4} => :floor,
    {0,5} => :empty, {0,6} => :empty, {0,7} => :floor, {0,8} => :empty, {0,9} => :empty,
    {1,0} => :empty, {1,1} => :empty, {1,2} => :empty, {1,3} => :empty, {1,4} => :empty,
    {1,5} => :empty, {1,6} => :empty, {1,7} => :floor, {1,8} => :empty, {1,9} => :empty}
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

  defp parse_col(raw, row, col, map) do
    Map.put(map, {row, col}, raw_to_val(raw))
  end

  defp raw_to_val("."), do: :floor
  defp raw_to_val("L"), do: :empty
  defp raw_to_val("#"), do: :occupied

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(0)
end
