defmodule Y2023.Day12 do
  use Advent.Day, no: 12

  def part1(input) do
    input
    |> Enum.map(&count_possibilities/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(&unfold/1)
    |> part1()
  end

  defp unfold(%{springs: springs, positions: positions}, count \\ 5) do
    springs = List.duplicate(springs, count) |> Enum.intersperse("?") |> List.flatten()
    positions = List.duplicate(positions, count) |> List.flatten()
    %{springs: springs, positions: positions}
  end

  defp count_possibilities(%{springs: springs} = row) do
    if "?" in springs do
      find_valid_possibilities(row)
    else
      1
    end
  end

  defp find_valid_possibilities(%{springs: springs, positions: positions}) do
    regex = ~r/^\.*#{position_regex(positions)}\.*$/

    unknown_positions =
      springs
      |> Enum.with_index()
      |> Enum.filter(fn {s, _p} -> s == "?" end)
      |> Enum.map(&elem(&1, 1))

    found_springs = Enum.count(springs, &(&1 == "#"))
    missing_spring_count = Enum.sum(positions) - found_springs

    unknown_positions
    |> Advent.combinations(missing_spring_count)
    |> Stream.chunk_every(1_000_000)
    |> Task.async_stream(
      fn list ->
        Enum.count(list, fn spring_positions ->
          string =
            to_replaced_springs(springs, spring_positions, 0)
            |> Enum.join()

          Regex.match?(regex, string)
        end)
      end,
      timeout: :infinity
    )
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  # Turn the list of positions into a regex string
  # eg. 1,1,3 becomes \#{1}\.+\#{1}\.+\#{3}
  defp position_regex(positions) do
    positions
    |> Enum.map(&"\#{#{&1}}")
    |> Enum.intersperse("\\.+")
    |> Enum.join()
  end

  defp replace_all([]), do: []
  defp replace_all(["?" | rest]), do: ["." | replace_all(rest)]
  defp replace_all([head | rest]), do: [head | replace_all(rest)]
  defp to_replaced_springs(springs, [], _position), do: replace_all(springs)

  defp to_replaced_springs(springs, [position | rest], position) do
    ["#" | to_replaced_springs(tl(springs), rest, position + 1)]
  end

  defp to_replaced_springs([head | tail], positions, position) do
    head = if head == "?", do: ".", else: head
    [head | to_replaced_springs(tail, positions, position + 1)]
  end

  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [springs, positions] = String.split(row, " ")

      %{
        springs: String.graphemes(springs),
        positions: String.split(positions, ",") |> Enum.map(&String.to_integer/1)
      }
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
