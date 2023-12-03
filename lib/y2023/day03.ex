defmodule Y2023.Day03 do
  use Advent.Day, no: 03

  def part1(%{numbers: numbers, symbols: symbols}) do
    symbol_positions = Map.keys(symbols)

    numbers
    |> Enum.filter(&next_to_symbol?(&1, symbol_positions))
    |> Enum.map(fn {_, %{number: number}} -> number end)
    |> Enum.sum()
  end

  defp next_to_symbol?({position, %{length: length}}, symbol_positions) do
    position
    |> calculate_surrounding_positions(length)
    |> Enum.any?(&Enum.member?(symbol_positions, &1))
  end

  # 27998156 - too low
  def part2(%{numbers: numbers, symbols: symbols}) do
    number_positions = invert_numbers(numbers)

    symbols
    |> Enum.filter(fn {_position, symbol} -> symbol == "*" end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&adjacent_numbers(&1, number_positions))
    |> Enum.filter(fn list -> length(list) == 2 end)
    |> Enum.reduce(0, fn [a, b], acc -> acc + a * b end)
  end

  defp calculate_surrounding_positions({row, col}, length \\ 1) do
    [{row, col - 1}, {row, col + length}] ++
      row_positions(row + 1, col, length) ++ row_positions(row - 1, col, length)
  end

  defp row_positions(row, col, length) do
    Enum.map((col - 1)..(col + length), &{row, &1})
  end

  # For part 1, numbers were useful to store as `%{position -> %{number, length}}`
  # But for part 2, we want the set of positions each number covers
  defp invert_numbers(numbers) do
    numbers
    |> Enum.reduce([], fn {{row, col}, %{number: number, length: length}}, acc ->
      positions = Enum.map(col..(col + length - 1), fn col -> {row, col} end) |> MapSet.new()
      [{number, positions} | acc]
    end)
  end

  defp adjacent_numbers(position, numbers) do
    surrounding_positions = MapSet.new(calculate_surrounding_positions(position))

    numbers
    |> Enum.reject(fn {_number, positions} ->
      MapSet.disjoint?(positions, surrounding_positions)
    end)
    |> Enum.map(&elem(&1, 0))
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{numbers: %{}, symbols: %{}}, fn {row, row_no}, acc ->
      %{
        numbers: read_numbers(row, row_no, acc.numbers),
        symbols: read_symbols(row, row_no, acc.symbols)
      }
    end)
  end

  # Store a map of all of the numbers in the input, in the format
  # `%{{row, col} => %{number: number, length: length}`
  defp read_numbers(row, row_no, acc) do
    numbers = Regex.scan(~r/[0-9]+/, row, return: :binary)
    indexes = Regex.scan(~r/[0-9]+/, row, return: :index)

    numbers
    |> Enum.zip(indexes)
    |> Enum.reduce(acc, fn {[number], [{col, length}]}, acc ->
      Map.put(acc, {row_no, col}, %{number: String.to_integer(number), length: length})
    end)
  end

  # Store a map of all of the symbols in the input, in the format
  # `%{{row, col} => "symbol"}`
  defp read_symbols(row, row_no, acc) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {val, col_no}, acc ->
      if val not in [".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
        Map.put(acc, {row_no, col_no}, val)
      else
        acc
      end
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
