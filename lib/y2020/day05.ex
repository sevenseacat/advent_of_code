defmodule Y2020.Day05 do
  use Advent.Day, no: 5

  def part1(input) do
    input
    |> Enum.map(&parse_pass/1)
    |> Enum.max_by(fn %{seat_id: seat_id} -> seat_id end)
  end

  @doc """
  iex> Day05.parse_pass("FBFBBFFRLR")
  %{row: 44, col: 5, seat_id: 357}

  iex> Day05.parse_pass("BFFFBBFRRR")
  %{row: 70, col: 7, seat_id: 567}

  iex> Day05.parse_pass("FFFBBBFRRR")
  %{row: 14, col: 7, seat_id: 119}

  iex> Day05.parse_pass("BBFFBBFRLL")
  %{row: 102, col: 4, seat_id: 820}
  """
  def parse_pass(<<row::binary-size(7), col::binary-size(3)>>) do
    row = parse_val(row, "F", "B", 0, 127)
    col = parse_val(col, "L", "R", 0, 7)

    %{row: row, col: col, seat_id: row * 8 + col}
  end

  defp parse_val("", _lower, _higher, val, val), do: val

  defp parse_val(<<lower::binary-size(1), rest::binary>>, lower, higher, min, max) do
    # IO.puts("val is #{lower}, range is now #{min} - #{div(max - min, 2) + min}")
    parse_val(rest, lower, higher, min, div(max - min, 2) + min)
  end

  defp parse_val(<<higher::binary-size(1), rest::binary>>, lower, higher, min, max) do
    # IO.puts("val is #{higher}, min is now #{div(max - min, 2) + min + 1} - #{max}")
    parse_val(rest, lower, higher, div(max - min, 2) + min + 1, max)
  end

  def part2(input) do
    input
    |> Stream.map(&parse_pass/1)
    |> Stream.map(fn %{seat_id: seat_id} -> seat_id end)
    |> Enum.sort()
    |> find_gap
  end

  defp find_gap([a, b | rest]) when a == b - 1, do: find_gap([b | rest])
  defp find_gap([a | _rest]), do: a + 1

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.get(:seat_id)
  def part2_verify, do: input() |> parse_input() |> part2()
end
