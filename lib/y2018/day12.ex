defmodule Y2018.Day12 do
  use Advent.Day, no: 12

  def part1(initial, rules, generation) do
    rules = parse_input(rules)
    do_part1(String.to_charlist(initial), rules, 1, generation, {0, 0})
  end

  def initial do
    "##.#.#.##..#....######..#..#...#.#..#.#.#..###.#.#.#..#..###.##.#..#.##.##.#.####..##...##..#..##.#."
  end

  defp do_part1(pots, _, current_gen, max_gen, _) when current_gen > max_gen do
    sum_pots(pots, -max_gen * 2)
  end

  defp do_part1(pots, rules, current_gen, max_gen, {last_score, last_increase}) do
    state = run_generation(pad_pots(pots), [], rules)
    new_score = sum_pots(state, -current_gen * 2)
    new_increase = new_score - last_score

    # Equilibrium has been reached - the rest is a simple calculation because the
    # increase is going to be constant the rest of the way to 50,000,000,000.
    if(new_increase == last_increase) do
      last_score + new_increase * (max_gen - current_gen + 1)
    else
      do_part1(state, rules, current_gen + 1, max_gen, {new_score, new_increase})
    end
  end

  defp pad_pots(pots), do: [?., ?., ?., ?.] ++ pots ++ [?., ?., ?., ?.]

  # c is the pot that can change.
  defp run_generation([a, b, c, d, e | rest], new_gen, rules) do
    new_c = rule_replacement(rules, [a, b, c, d, e])
    run_generation([b, c, d, e | rest], [new_c | new_gen], rules)
  end

  defp run_generation(_, new_gen, _) do
    Enum.reverse(new_gen)
  end

  defp rule_replacement(rules, matcher) do
    case Enum.find(rules, fn {input, _} -> input == matcher end) do
      nil -> ?.
      {_, output} -> output
    end
  end

  defp sum_pots(pots, start_from) do
    pots
    |> Enum.zip(start_from..length(pots))
    |> Enum.filter(fn {plant, _pot} -> plant == ?# end)
    |> Enum.map(fn {_plant, pot} -> pot end)
    |> Enum.sum()
  end

  def parse_input(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [input, output] = String.split(row, " => ")
    {String.to_charlist(input), hd(String.to_charlist(output))}
  end

  def part1_verify, do: part1(initial(), input(), 20)
  def part2_verify, do: part1(initial(), input(), 50_000_000_000)
end
