defmodule Y2020.Day16 do
  use Advent.Day, no: 16

  def part1(input) do
    input.nearby
    |> find_invalid_values(input.fields)
    |> Enum.sum()
  end

  def part2(input, field_filter) do
    input
    |> reject_invalid_tickets()
    |> determine_fields()
    |> Enum.filter(fn {name, _index} -> String.starts_with?(name, field_filter) end)
    |> Enum.map(fn {_name, index} -> Enum.at(input.me, index) end)
    |> Enum.product()
  end

  defp reject_invalid_tickets(input) do
    Map.update!(input, :nearby, fn nearby ->
      nearby
      |> Enum.filter(fn vals ->
        Enum.all?(vals, &valid_value?(&1, input.fields))
      end)
    end)
  end

  def determine_fields(input) do
    do_determine_fields([input.me | input.nearby], input.fields, [], length(input.fields))
  end

  defp do_determine_fields(_tickets, _fields, determined, field_count)
       when field_count == length(determined) do
    determined
  end

  defp do_determine_fields(tickets, undetermined_fields, determined, field_count) do
    undetermined_indexes =
      Enum.to_list(0..(field_count - 1)) -- Enum.map(determined, &elem(&1, 1))

    determination =
      Enum.map(undetermined_indexes, fn index ->
        {index,
         Enum.map(tickets, fn ticket ->
           valid_fields(Enum.at(ticket, index), undetermined_fields)
         end)}
      end)
      |> Enum.map(fn {index, set} -> {index, Advent.common_elements(set)} end)
      |> Enum.find(fn {_index, set} -> length(set) == 1 end)

    case determination do
      nil ->
        raise "Could not determine any fields! Determined so far: #{inspect(determined)}"

      {index, [field]} ->
        fields = Enum.reject(undetermined_fields, fn {name, _} -> name == field end)
        do_determine_fields(tickets, fields, [{field, index} | determined], field_count)
    end
  end

  defp valid_fields(value, fields) do
    fields
    |> Enum.filter(&valid_for_field?(&1, value))
    |> Enum.map(&elem(&1, 0))
  end

  defp find_invalid_values(nearby, fields) do
    nearby
    |> Enum.reduce([], fn nearby, acc ->
      Enum.reduce(nearby, acc, fn x, acc ->
        if(valid_value?(x, fields), do: acc, else: [x | acc])
      end)
    end)
  end

  defp valid_value?(val, fields) do
    Enum.any?(fields, &valid_for_field?(&1, val))
  end

  defp valid_for_field?({_name, [range1, range2]}, value) do
    in_range?(range1, value) || in_range?(range2, value)
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
    |> Enum.reduce([], fn field, acc ->
      [name | numbers] =
        Regex.run(~r/^([\w|\s]+): (\d+)-(\d+) or (\d+)-(\d+)/, field, capture: :all_but_first)

      numbers =
        Enum.map(numbers, &String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.map(&List.to_tuple/1)

      [{name, numbers} | acc]
    end)
    |> Enum.reverse()
  end

  defp numbers(string) do
    ~r/\d+/
    |> Regex.scan(string)
    |> Enum.map(&(hd(&1) |> String.to_integer()))
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2("departure")
end
