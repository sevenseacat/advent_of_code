defmodule Y2020.Day20 do
  use Advent.Day, no: 20

  alias Y2020.Day20.Tile

  def part1(input) do
    side_length =
      :math.sqrt(length(input))
      |> trunc()
      |> IO.inspect()

    # Let's brute force this thing!
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_tile/1)
  end

  defp parse_tile(input) do
    [number | content] = String.split(input, "\n")

    [_, number] = Regex.run(~r/Tile (\d+):/, number)
    content = Enum.map(content, &String.graphemes/1)

    rotated = Advent.transpose(content)

    %Tile{
      number: String.to_integer(number),
      version: nil,
      versions: Tile.generate_versions(content)
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Enum.product()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
