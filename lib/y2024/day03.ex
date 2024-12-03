defmodule Y2024.Day03 do
  use Advent.Day, no: 03

  @doc """
  iex> Day03.part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
  161
  """
  def part1(input) do
    ~r/(mul)\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.reduce(0, fn ["mul", one, two], acc ->
      acc + String.to_integer(one) * String.to_integer(two)
    end)
  end

  @doc """
  iex> Day03.part2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
  48
  """
  def part2(input) do
    ~r/(mul)\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/
    |> Regex.scan(input)
    |> Enum.reduce({0, true}, fn
      ["do()"], {acc, _} ->
        {acc, true}

      ["don't()"], {acc, _} ->
        {acc, false}

      [_, "mul", one, two], {acc, do?} ->
        if do? do
          {acc + String.to_integer(one) * String.to_integer(two), true}
        else
          {acc, false}
        end
    end)
    |> elem(0)
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
