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

  defp calculate_surrounding_positions({row, col}, length) do
    [{row, col - 1}, {row, col + length}] ++
      row_positions(row + 1, col, length) ++ row_positions(row - 1, col, length)
  end

  defp row_positions(row, col, length) do
    Enum.map((col - 1)..(col + length), &{row, &1})
  end

  # @doc """
  # iex> Day03.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

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
  # def part2_verify, do: input() |> parse_input() |> part2()
end
