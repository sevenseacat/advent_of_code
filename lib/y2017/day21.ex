defmodule Y2017.Day21 do
  use Advent.Day, no: 21

  alias Y2017.Day21.Rule

  @starting_grid [".#.", "..#", "###"]

  def part1(rules, iterations) do
    do_part1(@starting_grid, parse_input(rules), 0, iterations)
    |> count_on_pixels
  end

  defp do_part1(grid, _, iteration, iteration), do: grid

  defp do_part1(grid, rules, iteration, max_iterations) do
    grid
    |> disassemble
    |> transform_chunks(rules)
    |> reassemble
    |> do_part1(rules, iteration + 1, max_iterations)
  end

  def disassemble(grid) do
    chunk_size = if rem(String.length(hd(grid)), 2) == 0, do: 2, else: 3

    grid
    # https://stackoverflow.com/a/43062529/560215
    |> Enum.map(&for <<x::binary-size(chunk_size) <- &1>>, do: x)
    |> Enum.chunk_every(chunk_size)
    |> Enum.flat_map(&transpose/1)
  end

  # https://stackoverflow.com/a/42887944/560215
  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def transform_chunks(grid, rules) do
    Enum.map(grid, &transform_chunk(&1, rules))
  end

  defp transform_chunk(chunk, rules) do
    chunk
    |> Rule.matching(rules)
    |> Map.get(:output)
  end

  def reassemble(grid) do
    chunk_size = :math.sqrt(length(grid)) |> trunc

    grid
    |> Enum.chunk_every(chunk_size)
    |> Enum.flat_map(&transpose/1)
    |> Enum.map(&Enum.join/1)
  end

  def count_on_pixels(grid) do
    grid
    |> Enum.reduce(0, fn line, acc ->
      acc +
        (line
         |> String.codepoints()
         |> Enum.count(&(&1 == "#")))
    end)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&input_line_to_rule/1)
  end

  defp input_line_to_rule(string) do
    string
    |> String.split(" => ")
    |> Enum.map(&String.split(&1, "/"))
    |> Rule.new()
  end

  def part1_verify, do: input() |> part1(5)
  def part2_verify, do: input() |> part1(18)
end
