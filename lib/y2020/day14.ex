defmodule Y2020.Day14 do
  use Advent.Day, no: 14

  def part1(input) do
    cache =
      Enum.reduce(input, %{}, fn {mask, ops}, cache ->
        Enum.reduce(ops, cache, fn %{position: position, value: value}, cache ->
          Map.put(cache, position, apply_bitmask(mask, value))
        end)
      end)

    {cache, Map.values(cache) |> Enum.sum()}
  end

  def apply_bitmask(mask, value) do
    binary_value =
      Integer.to_string(value, 2)
      |> String.pad_leading(36, "0")
      |> String.graphemes()

    Enum.reduce(mask, binary_value, fn {position, value}, binary ->
      List.replace_at(binary, position, value)
    end)
    |> Enum.join("")
    |> String.to_integer(2)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> chunk_input()
    |> tl()
    |> Enum.map(&parse_chunk/1)
  end

  defp chunk_input(input) do
    Enum.chunk_while(
      input,
      [],
      fn row, acc ->
        if String.starts_with?(row, "mask") do
          {:cont, Enum.reverse(acc), [row]}
        else
          {:cont, [row | acc]}
        end
      end,
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
  end

  defp parse_chunk([mask | ops]) do
    {parse_mask(mask), Enum.map(ops, &parse_op/1)}
  end

  defp parse_mask(mask) do
    mask
    |> String.trim_leading("mask = ")
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reject(fn {val, _index} -> val == "X" end)
    |> Map.new(fn {val, index} -> {index, String.to_integer(val)} end)
  end

  defp parse_op(op) do
    [[_, position, value]] = Regex.scan(~r/mem\[(\d+)\] = (\d+)/, op)
    %{position: String.to_integer(position), value: String.to_integer(value)}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
end
