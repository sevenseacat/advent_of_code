defmodule Y2023.Day12 do
  use Advent.Day, no: 12

  def part1(input) do
    input
    |> Task.async_stream(&count_possibilities/1)
    |> Enum.map(&elem(&1, 1))
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
    state = %{
      expected: positions,
      dot_allowed: true,
      dash_allowed: true
    }

    do_search({springs, [{state, 1}]}, {tl(springs), Map.new()}, 0)
  end

  defp add_to_queue(states, queue, count) do
    Enum.reduce(states, queue, fn state, queue ->
      Map.update(queue, state, count, &(&1 + count))
    end)
  end

  defp do_search({_, []}, {nil, _}, match_count), do: match_count

  defp do_search({_, []}, {chars, state}, match_count) do
    # Terminate by setting a nil value for the next level (picked up by the clause above)
    next = if chars == [], do: nil, else: tl(chars)
    do_search({chars, Enum.to_list(state)}, {next, Map.new()}, match_count)
  end

  defp do_search({chars, [{state, count} | rest]}, {next_chars, next_level}, match_count) do
    if state.expected == [] do
      count = if Enum.any?(chars, &(&1 == "#")), do: match_count, else: match_count + count
      do_search({chars, rest}, {next_chars, next_level}, count)
    else
      next_level =
        process_character(chars, state)
        |> add_to_queue(next_level, count)

      do_search({chars, rest}, {next_chars, next_level}, match_count)
    end
  end

  defp process_character([], %{expected: expected}) when expected != [], do: []

  # This can probably be *way* simplified but it works.
  # `dash` should be hash (#) but I got used to calling them dot and dash
  defp process_character([char | _], %{expected: expected, dot_allowed: dot, dash_allowed: dash}) do
    case {char, dot, dash} do
      {"#", _dot, false} ->
        []

      {"#", _dot, true} ->
        [char_is_dash(expected)]

      {".", true, _dash} ->
        [char_is_dot(expected)]

      {".", false, _dash} ->
        []

      {"?", false, false} ->
        []

      {"?", true, false} ->
        [char_is_dot(expected)]

      {"?", false, true} ->
        [char_is_dash(expected)]

      {"?", true, true} ->
        [char_is_dot(expected), char_is_dash(expected)]
    end
  end

  defp char_is_dot(expected) do
    %{
      expected: expected,
      dot_allowed: true,
      dash_allowed: true
    }
  end

  defp char_is_dash([next | rest]) do
    case next do
      1 ->
        %{
          expected: rest,
          dot_allowed: true,
          dash_allowed: false
        }

      num ->
        %{
          expected: [num - 1 | rest],
          dot_allowed: false,
          dash_allowed: true
        }
    end
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
  def part2_verify, do: input() |> parse_input() |> part2()
end
