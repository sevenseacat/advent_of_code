defmodule Y2023.Day05 do
  use Advent.Day, no: 05

  @operation_order [:soil, :fertilizer, :water, :light, :temperature, :humidity, :location]

  def part1(input) do
    conversion_rules = generate_conversion_rules(input)

    input.seeds
    |> Enum.map(&convert(conversion_rules, &1))
    |> Enum.min()
  end

  def part2(input) do
    seed_ranges =
      input.seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [min, range] -> %{min: min, max: min + range - 1} end)

    order = [:seed | @operation_order]

    data = invert_data(input, order, %{})

    # Run the translation in reverse, from location 0 until we find a valid seed.
    check_valid_location(0, data, seed_ranges, tl(Enum.reverse(order)))
  end

  defp generate_conversion_rules(input) do
    @operation_order
    |> Enum.reduce(%{}, fn key, acc ->
      data =
        input
        |> Map.fetch!(key)
        |> Enum.map(fn rule ->
          %{
            min: rule.source,
            max: rule.source + rule.size - 1,
            offset: rule.destination - rule.source
          }
        end)

      Map.put(acc, key, data)
    end)
  end

  defp invert_data(_input, [:location], data), do: data

  defp invert_data(input, [prev, next | rest], data) do
    rules = Map.fetch!(input, next)

    inverted_rules =
      Enum.map(rules, fn rule ->
        %{
          min: rule.destination,
          max: rule.destination + rule.size - 1,
          offset: rule.source - rule.destination
        }
      end)

    data = Map.put(data, prev, inverted_rules)
    invert_data(input, [next | rest], data)
  end

  defp check_valid_location(location, input, seed_ranges, order) do
    seed = convert(input, location, order)

    if Enum.find(seed_ranges, fn range -> seed >= range.min && seed <= range.max end) do
      location
    else
      check_valid_location(location + 1, input, seed_ranges, order)
    end
  end

  defp convert(input, val, order \\ @operation_order) do
    Enum.reduce(order, val, fn operation, current ->
      do_convert(input, operation, current)
    end)
  end

  defp do_convert(input, operation, current) do
    key =
      input
      |> Map.fetch!(operation)
      |> Enum.find(fn rule -> current >= rule.min && current <= rule.max end)

    case key do
      nil -> current
      %{offset: offset} -> offset + current
    end
  end

  def parse_input(input) do
    ["seeds: " <> seeds | maps] = String.split(input, "\n\n", trim: true)

    maps
    |> Enum.reduce(%{seeds: parse_numbers(seeds)}, fn map, acc ->
      {name, data} = parse_map(map)
      Map.put(acc, String.to_atom(name), data)
    end)
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_map(map) do
    [name | data] = String.split(map, "\n", trim: true)

    [_, "to", name, "map:"] = String.split(name, ["-", " "])

    data =
      Enum.map(data, fn row ->
        [destination, source, size] = parse_numbers(row)
        %{source: source, destination: destination, size: size}
      end)

    {name, data}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
