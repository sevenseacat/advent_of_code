defmodule Y2024.Day22 do
  use Advent.Day, no: 22

  @doc """
  iex> Day22.part1([1, 10, 100, 2024])
  37327623
  """
  def part1(input) do
    input
    |> Enum.map(&get_secret_number(&1, 2000))
    |> Enum.sum()
  end

  # @doc """
  # iex> Day22.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp get_secret_number(num, 0), do: num
  defp get_secret_number(num, index), do: get_secret_number(next(num), index - 1)

  @doc """
  iex> Day22.next(123)
  15887950

  iex> Day22.next(15887950)
  16495136
  """
  def next(number) do
    num1 =
      (64 * number)
      |> mix(number)
      |> prune()

    num2 =
      num1
      |> div(32)
      |> floor()
      |> mix(num1)
      |> prune()

    (num2 * 2048)
    |> mix(num2)
    |> prune()
  end

  defp mix(one, two), do: Bitwise.bxor(one, two)
  defp prune(one), do: rem(one, 16_777_216)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
