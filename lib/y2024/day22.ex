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

  @doc """
  iex> Day22.part2([1, 2, 3, 2024])
  {[-2, 1, -1, 3], 23}
  """
  def part2(input) do
    data = Enum.map(input, &compute_sell_sequences(&1, 2000, %{}, []))

    Enum.reduce(-9..9, {nil, 0}, fn i, state ->
      Enum.reduce(-9..9, state, fn j, state ->
        Enum.reduce(-9..9, state, fn k, state ->
          Enum.reduce(-9..9, state, fn l, {s, acc} ->
            result = Enum.sum(check_sequence([i, j, k, l], data))

            if result > acc do
              {[i, j, k, l], result}
            else
              {s, acc}
            end
          end)
        end)
      end)
    end)
  end

  defp get_secret_number(num, 0), do: num
  defp get_secret_number(num, index), do: get_secret_number(next(num), index - 1)

  def compute_sell_sequences(_, 0, state, _seen), do: state

  def compute_sell_sequences(num, turn, state, seen) do
    next = next(num)
    key = [rem(next, 10) - rem(num, 10) | Enum.take(seen, 3)]
    compute_sell_sequences(next, turn - 1, Map.put_new(state, key, rem(next, 10)), key)
  end

  @doc """
  iex> data = [Y2024.Day22.compute_sell_sequences(123, 10, %{}, [])]
  iex> Y2024.Day22.check_sequence([-1, -1, 0, 2], data)
  [6]

  iex> data = Enum.map([1, 2, 3, 2024], &Y2024.Day22.compute_sell_sequences(&1, 2000, %{}, []))
  iex> Y2024.Day22.check_sequence([-2, 1, -1, 3], data)
  [7, 7, 0, 9]
  """
  def check_sequence(check, data) do
    check = Enum.reverse(check)

    Enum.map(data, fn sequence ->
      Map.get(sequence, check, 0)
    end)
  end

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
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
