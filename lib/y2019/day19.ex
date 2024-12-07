defmodule Y2019.Day19 do
  use Advent.Day, no: 19
  alias Y2019.Intcode

  def part1(program, grid_size \\ 50) do
    coords = for x <- 0..(grid_size - 1), y <- 0..(grid_size - 1), do: [x, y]

    coords
    |> Task.async_stream(fn [x, y] ->
      results =
        program
        |> Intcode.new([x, y])
        |> Intcode.run()
        |> Intcode.outputs()

      {{x, y}, hd(results)}
    end)
    # |> Advent.Grid.display()
    |> Enum.count(fn {:ok, {_coord, val}} -> val == 1 end)
  end

  # @doc """
  # iex> Day19.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> Intcode.from_string()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
