defmodule Y2023.Day05 do
  use Advent.Day, no: 05

  @operation_order [:soil, :fertilizer, :water, :light, :temperature, :humidity, :location]

  def part1(input) do
    input.seeds
    |> Enum.map(&run_translation_list(input, &1, :seed))
  end

  # 57451710 - too high
  def part2(input) do
    seed_ranges =
      input.seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, range] -> start..(start + range - 1) end)

    order = [:seed | @operation_order]

    data =
      invert_data(input, order, %{})

    # Run the translation in reverse, from location 0 until we find a valid seed.
    check_valid_location(0, data, seed_ranges, tl(Enum.reverse(order)))
  end

  defp invert_data(_input, [:location], data), do: data

  defp invert_data(input, [prev, next | rest], data) do
    rules = Map.fetch!(input, next)

    inverted_rules =
      Enum.map(rules, fn rule ->
        %{source: rule.destination, destination: rule.source, size: rule.size}
      end)

    data = Map.put(data, prev, inverted_rules)
    invert_data(input, [next | rest], data)
  end

  defp check_valid_location(location, input, seed_ranges, order) do
    response = run_translation_list(input, location, :location, order)
    seed = Map.fetch!(response, :seed)

    if Enum.find(seed_ranges, fn range -> seed in range end) do
      location
    else
      check_valid_location(location + 1, input, seed_ranges, order)
    end
  end

  defp run_translation_list(input, val, start_key, order \\ @operation_order) do
    Enum.reduce(order, {%{start_key => val}, val}, fn operation, {acc, current} ->
      translation = translate(input, operation, current)
      {Map.put(acc, operation, translation), translation}
    end)
    |> elem(0)
  end

  defp translate(input, operation, current) do
    key =
      input
      |> Map.fetch!(operation)
      |> Enum.find(fn rule -> current >= rule.source && current < rule.source + rule.size end)

    case key do
      nil -> current
      %{source: source, destination: destination} -> destination + (current - source)
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

  def part1_verify do
    input() |> parse_input() |> part1() |> Enum.min_by(& &1.location) |> Map.fetch!(:location)
  end

  def part2_verify, do: input() |> parse_input() |> part2()
end
