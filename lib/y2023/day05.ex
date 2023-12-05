defmodule Y2023.Day05 do
  use Advent.Day, no: 05

  @operation_order [:soil, :fertilizer, :water, :light, :temperature, :humidity, :location]

  def part1(input) do
    input.seeds
    |> Enum.map(fn seed ->
      Enum.reduce(@operation_order, {%{seed: seed}, seed}, fn operation, {acc, current} ->
        translation = translate(input, operation, current)
        {Map.put(acc, operation, translation), translation}
      end)
      |> elem(0)
    end)
  end

  # @doc """
  # iex> Day05.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp translate(input, operation, current) do
    key =
      input
      |> Map.fetch!(operation)
      |> Enum.find(fn rule -> current >= rule.source && current <= rule.source + rule.size end)

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

  # def part2_verify, do: input() |> parse_input() |> part2()
end
