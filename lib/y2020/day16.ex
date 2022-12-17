defmodule Y2020.Day16 do
  use Advent.Day, no: 16

  def part1(input) do
    input.nearby
    |> find_invalid_values(input.fields)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day16.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp find_invalid_values(nearby, fields) do
    nearby
    |> Enum.reduce([], fn nearby, acc ->
      Enum.reduce(nearby, acc, fn x, acc ->
        if(valid_value?(x, fields), do: acc, else: [x | acc])
      end)
    end)
  end

  defp valid_value?(val, fields) do
    Enum.any?(fields, fn {_, [range1, range2]} ->
      in_range?(range1, val) || in_range?(range2, val)
    end)
  end

  defp in_range?({from, to}, val), do: val >= from && val <= to

  def parse_input(input) do
    [fields, me, nearby] = String.split(input, "\n\n", trim: true)

    %{
      fields: parse_fields(fields),
      me: numbers(me),
      nearby: String.split(nearby, "\n", trim: true) |> tl |> Enum.map(&numbers/1)
    }
  end

  defp parse_fields(fields) do
    fields
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn field, acc ->
      [name | numbers] =
        Regex.run(~r/(\w+): (\d+)-(\d+) or (\d+)-(\d+)/, field, capture: :all_but_first)

      numbers =
        Enum.map(numbers, &String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.map(&List.to_tuple/1)

      Map.put(acc, String.to_atom(name), numbers)
    end)
  end

  defp numbers(string) do
    ~r/\d+/
    |> Regex.scan(string)
    |> Enum.map(&(hd(&1) |> String.to_integer()))
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
