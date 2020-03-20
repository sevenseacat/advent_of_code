defmodule Y2019.Day14 do
  use Advent.Day, no: 14

  def part1(input, required_count \\ 1, debug \\ false) do
    {[{"ORE", count}], _extras} =
      do_part1(input, [{"FUEL", required_count}], "ORE", [], [], debug)

    count
  end

  def part2(input, debug \\ false) do
    total_ore = 1_000_000_000_000

    # We'll be able to make at least (ore_left / fuel_for_one_ore) fuel
    # But maybe more depending on extras left over
    ore_per_fuel = part1(input, 1, debug)
    {min_fuel, min_ore, extras} = lcm(input, total_ore, ore_per_fuel)

    do_part2(input, total_ore - min_ore, extras, min_fuel, debug)
  end

  defp do_part1(_, [], _, used, extras, _), do: {used, extras}

  defp do_part1(data, [{type, count} | rest], base_type, used, extras, debug) do
    if debug do
      IO.puts("-----")
    end

    # Find how to make the needed component
    {ingredients, {_, formula_count}} = formula = Enum.find(data, fn {_, {t, _}} -> t == type end)

    {extras, needed_count} = use_extras(extras, type, count)

    if debug do
      IO.puts("Making: #{count} #{type}")
      IO.puts("(Taking #{count - needed_count} from extras)")
    end

    if needed_count == 0 do
      # Don't need to do anything, we pulled everything required from the extras, move to the next needed component.
      do_part1(data, rest, base_type, used, extras, debug)
    else
      if debug do
        IO.puts("Needed: #{needed_count} #{type}")
        IO.puts("Using formula to synthesize: #{inspect(formula)}")
        IO.puts("Still to make: #{inspect(rest)}")
      end

      {scale, created_ingredients} =
        scale_up_ingredients(ingredients, formula_count, needed_count)

      extra_count = formula_count * scale - needed_count
      extras = if extra_count > 0, do: add_extras(extras, type, extra_count), else: extras

      if debug do
        IO.puts("EXTRAS: #{inspect(extras)}")
      end

      {needed, used, extras} =
        use_ingredients(
          created_ingredients,
          base_type,
          used,
          extras
        )

      do_part1(data, Enum.concat(needed, rest), base_type, used, extras, debug)
    end
  end

  defp do_part2(_, ore_left, _, fuel_made, _) when ore_left < 0, do: fuel_made - 1

  defp do_part2(input, ore_left, extras, fuel_made, debug) do
    {[{"ORE", ore_used}], extras} = do_part1(input, [{"FUEL", 1}], "ORE", [], extras, debug)

    ore_left = ore_left - ore_used
    fuel_made = fuel_made + 1

    do_part2(input, ore_left, extras, fuel_made, debug)
  end

  # Calculate what's the lowest fractional multiple of the minimum fuel, without going over the
  # total amount of available ore.
  defp lcm(input, total_ore, ore_per_fuel, multiple \\ 1) do
    {_, ore, _} = calc_lcm(input, total_ore, ore_per_fuel, multiple)

    if ore > total_ore do
      # this multiple is too high, dial it back a notch.
      calc_lcm(input, total_ore, ore_per_fuel, multiple - 0.01)
    else
      lcm(input, total_ore, ore_per_fuel, multiple + 0.01)
    end
  end

  defp calc_lcm(input, total_ore, ore_per_fuel, multiple) do
    min_fuel = floor(div(total_ore, ore_per_fuel) * multiple)
    {[{"ORE", min_ore}], extras} = do_part1(input, [{"FUEL", min_fuel}], "ORE", [], [], false)

    {min_fuel, min_ore, extras}
  end

  defp use_extras([], _, count), do: {[], count}

  defp use_extras([{type, num} | rest], type, count) do
    {[{type, max(num - count, 0)} | rest], max(count - num, 0)}
  end

  defp use_extras([item | rest], type, count) do
    {extras, count} = use_extras(rest, type, count)
    {[item | extras], count}
  end

  defp add_extras([], type, count), do: [{type, count}]
  defp add_extras([{type, num} | rest], type, count), do: [{type, num + count} | rest]
  defp add_extras([item | rest], type, count), do: [item | add_extras(rest, type, count)]

  defp use_ingredients(
         created_ingredients,
         base_type,
         used,
         extras
       ) do
    # This is going to create needed_type
    # Created ingredients can be split into those we need to dig down into, those that are ext
    {base_elements, needed} =
      Enum.split_with(created_ingredients, fn {type, _count} -> type == base_type end)

    {needed, add_base_elements(base_elements, used), extras}
  end

  defp add_base_elements([], used), do: used
  defp add_base_elements(used, []), do: used

  defp add_base_elements([{type, new_count}], [{type, old_count}]),
    do: [{type, old_count + new_count}]

  defp scale_up_ingredients(ingredients, formula_count, needed_count)
       when formula_count >= needed_count do
    # The recipe covers the cost, no scaling needed
    {1, ingredients}
  end

  defp scale_up_ingredients(ingredients, formula_count, needed_count) do
    # Need to make multiples of the recipe to cover what is needed
    scale = ceil(needed_count / formula_count)
    {scale, Enum.map(ingredients, fn {type, count} -> {type, count * scale} end)}
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(input) do
    [inputs, output] = String.split(input, " => ")
    {inputs |> String.split(", ") |> to_list |> Enum.reverse(), to_list([output]) |> hd}
  end

  defp to_list(list) do
    Enum.reduce(list, [], fn i, acc ->
      [count, type] = String.split(i, " ")
      [{type, String.to_integer(count)} | acc]
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
