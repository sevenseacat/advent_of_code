defmodule Y2015.Day15 do
  use Advent.Day, no: 15

  @max_teaspoons 100

  @doc """
  iex> Day15.part1("Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  ...> Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3")
  {[{"Butterscotch", 44}, {"Cinnamon", 56}], 62842880}
  """
  def part1(input, teaspoons \\ @max_teaspoons) do
    # How to calculate permutations of ingredients that add up to @max_teaspoons ?
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
end
