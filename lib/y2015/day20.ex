defmodule Y2015.Day20 do
  use Advent.Day, no: 20

  @input 36_000_000

  @doc """
  iex> Day20.part1(30)
  2

  iex> Day20.part1(120)
  6

  iex> Day20.part1(69)
  4
  """
  def part1(at_least \\ @input) do
    find_answer(1, 10, at_least, &divisors/1)
  end

  def part2(at_least \\ @input) do
    elves_at_number = fn number ->
      divisors(number) |> Enum.filter(fn n -> number / n <= 50 end)
    end

    find_answer(1, 11, at_least, elves_at_number)
  end

  defp find_answer(number, presents_per_elf, at_least, elves_at_number) do
    if Enum.sum(elves_at_number.(number)) * presents_per_elf >= at_least do
      number
    else
      find_answer(number + 1, presents_per_elf, at_least, elves_at_number)
    end
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2()

  # Below adapted from https://rosettacode.org/wiki/Factors_of_an_integer#Elixir
  # Not sure about the differences between the two methods of finding divisors...
  def divisors(n), do: divisors(n, 1, [])

  defp divisors(n, i, factors) when n < i * i, do: factors
  defp divisors(n, i, factors) when n == i * i, do: [i | factors]

  defp divisors(n, i, factors) when rem(n, i) == 0 do
    divisors(n, i + 1, [i, div(n, i) | factors])
  end

  defp divisors(n, i, factors), do: divisors(n, i + 1, factors)
end
