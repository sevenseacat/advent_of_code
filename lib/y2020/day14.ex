defmodule Y2020.Day14 do
  use Advent.Day, no: 14

  def part1(input) do
    fun = fn cache, mask, %{position: position, value: value} ->
      Map.put(cache, position, apply_v1_bitmask(mask, value))
    end

    run_bitmasker(input, fun)
  end

  def part2(input) do
    fun = fn cache, mask, %{position: position, value: value} ->
      # Now it's not the value that will be bitmasked, its the position
      apply_v2_bitmask(mask, position)
      |> Enum.reduce(cache, fn new_position, acc ->
        Map.put(acc, new_position, value)
      end)
    end

    run_bitmasker(input, fun)
  end

  def run_bitmasker(input, fun) do
    cache =
      Enum.reduce(input, %{}, fn {mask, ops}, cache ->
        Enum.reduce(ops, cache, fn op, cache ->
          fun.(cache, mask, op)
        end)
      end)

    {cache, Map.values(cache) |> Enum.sum()}
  end

  def apply_v1_bitmask(mask, value) do
    Enum.reduce(mask, integer_to_binary(value), fn {position, value}, binary ->
      List.replace_at(binary, position, value)
    end)
    |> binary_to_integer()
  end

  def apply_v2_bitmask(mask, value) do
    binary_value = integer_to_binary(value)

    Enum.reduce(35..0//-1, [[]], fn index, acc ->
      case Map.get(mask, index) do
        nil -> Enum.reduce(acc, [], &[[0 | &1], [1 | &1] | &2])
        val -> Enum.map(acc, &[Bitwise.bor(val, Enum.at(binary_value, index)) | &1])
      end
    end)
    |> Enum.map(&binary_to_integer/1)
  end

  defp integer_to_binary(int) when is_integer(int) do
    int
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp binary_to_integer(list) when is_list(list) do
    list
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

  def parse_mask(mask) do
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
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
