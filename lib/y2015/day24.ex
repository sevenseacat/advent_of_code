defmodule Y2015.Day24 do
  use Advent.Day, no: 24

  def part1(input) do
    bucket_size = div(Enum.sum(input), 3)
    check_bucket_size(input, bucket_size, 1)
  end

  def check_bucket_size(packages, bucket_size, count) do
    matches =
      Advent.combinations(packages, count)
      |> Enum.filter(fn list -> Enum.sum(list) == bucket_size end)

    if matches == [] do
      check_bucket_size(packages, bucket_size, count + 1)
    else
      matches
      |> Enum.min_by(&quantum_entanglement/1)
      |> quantum_entanglement()
    end
  end

  def quantum_entanglement(set) do
    Enum.reduce(set, 1, fn x, acc -> acc * x end)
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
