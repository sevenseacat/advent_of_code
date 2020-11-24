defmodule Y2015.Day15 do
  use Advent.Day, no: 15

  @max_teaspoons 100

  @doc """
  iex> Day15.part1("Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  ...> Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3")
  {[{"Butterscotch", 44}, {"Cinnamon", 56}], 62842880}
  """
  def part1(input, teaspoons \\ @max_teaspoons) do
    rules = parse_input(input)

    rules
    |> combinations(teaspoons)
    |> Enum.map(fn quantities -> {quantities, score_for_cookie(quantities, rules)} end)
    |> Enum.max_by(fn {_, score} -> score end)
  end

  @doc """
  iex> Day15.part2("Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  ...> Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3")
  {[{"Butterscotch", 40}, {"Cinnamon", 60}], 57600000}
  """
  def part2(input, teaspoons \\ @max_teaspoons) do
    rules = parse_input(input)

    rules
    |> combinations(teaspoons)
    |> Enum.map(fn quantities -> {quantities, score_for_cookie(quantities, rules)} end)
    |> Enum.filter(fn {quantities, _score} -> calorie_count(quantities, rules) == 500 end)
    |> Enum.max_by(fn {_, score} -> score end)
  end

  def calorie_count(quantities, rules) do
    score_for_property(:calories, rules, quantities)
  end

  def score_for_cookie(quantities, rules) do
    [:capacity, :durability, :flavor, :texture]
    |> Enum.map(fn property -> score_for_property(property, rules, quantities) end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp score_for_property(property, rules, quantities) do
    quantities
    |> Enum.map(fn {name, quantity} ->
      rules
      |> Enum.find(fn rule -> rule.name == name end)
      |> Map.get(property)
      |> Kernel.*(quantity)
    end)
    |> Enum.sum()
    |> max(0)
  end

  defp combinations(rules, limit) do
    # "Combinations with repetitions" - https://rosettacode.org/wiki/Combinations_with_repetitions#Elixir
    # To get combinations of ingredients that add up to the required number of teaspoons
    names = Enum.map(rules, fn %{name: name} -> name end)

    limit
    |> __MODULE__.CombinationsRepetitions.run(names)
    |> Stream.map(&Enum.sort/1)
    |> Stream.uniq()
    |> Enum.map(&grouped/1)
  end

  defp grouped(list) do
    list
    |> Enum.group_by(& &1)
    |> Enum.map(fn {name, list} -> {name, length(list)} end)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  @doc """
  iex> Day15.parse_row("Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8")
  %{name: "Butterscotch", capacity: -1, durability: -2, flavor: 6, texture: 3, calories: 8}
  """
  def parse_row(row) do
    [[_string, name, capacity, durability, flavor, texture, calories]] =
      Regex.scan(
        ~r/(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/,
        row
      )

    %{
      name: name,
      capacity: String.to_integer(capacity),
      durability: String.to_integer(durability),
      flavor: String.to_integer(flavor),
      texture: String.to_integer(texture),
      calories: String.to_integer(calories)
    }
  end

  def part1_verify, do: input() |> part1() |> elem(1)
  def part2_verify, do: input() |> part2() |> elem(1)

  # https://rosettacode.org/wiki/Combinations_with_repetitions#Elixir
  defmodule CombinationsRepetitions do
    def run(0, _), do: [[]]
    def run(_, []), do: []

    def run(n, [h | t] = s) do
      for(l <- run(n - 1, s), do: [h | l]) ++ run(n, t)
    end
  end
end
