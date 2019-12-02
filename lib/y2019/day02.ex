defmodule Y2019.Day02 do
  use Advent.Day, no: 2

  def part1(input) do
    input
    |> seed_program(12, 2)
    |> run_program
    |> hd
  end

  defp seed_program(list, noun, verb) do
    list
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  @doc """
  iex> Day02.run_program([1,0,0,0,99])
  [2,0,0,0,99]

  iex> Day02.run_program([2,3,0,3,99])
  [2,3,0,6,99]

  iex> Day02.run_program([2,4,4,5,99,0])
  [2,4,4,5,99,9801]

  iex> Day02.run_program([1,1,1,4,99,5,6,0,99])
  [30,1,1,4,2,5,6,0,99]
  """
  def run_program(list, pos \\ 0) do
    case Enum.at(list, pos) do
      1 -> do_stuff(list, pos, &Kernel.+/2) |> run_program(pos + 4)
      2 -> do_stuff(list, pos, &Kernel.*/2) |> run_program(pos + 4)
      99 -> list
      _ -> :error
    end
  end

  defp do_stuff(list, pos, op) do
    add1 = Enum.at(list, Enum.at(list, pos + 1))
    add2 = Enum.at(list, Enum.at(list, pos + 2))

    List.replace_at(
      list,
      Enum.at(list, pos + 3),
      op.(add1, add2)
    )
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
