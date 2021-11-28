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
    find_answer(1, 10, at_least)
  end

  defp find_answer(current, presents_per_elf, at_least) do
    if Enum.sum(divisors(current)) * 10 >= at_least do
      current
    else
      find_answer(current + 1, presents_per_elf, at_least)
    end
  end

  def part1_verify, do: part1()

  # Below adapted from https://rosettacode.org/wiki/Proper_divisors#Elixir
  # Includes that 1 and n are divisors of n
  def divisors(1), do: [1]
  def divisors(n), do: [1, n | divisors(2, n, :math.sqrt(n))] |> Enum.sort()

  defp divisors(k, _n, q) when k > q, do: []
  defp divisors(k, n, q) when rem(n, k) > 0, do: divisors(k + 1, n, q)
  defp divisors(k, n, q) when k * k == n, do: [k | divisors(k + 1, n, q)]
  defp divisors(k, n, q), do: [k, div(n, k) | divisors(k + 1, n, q)]
end
