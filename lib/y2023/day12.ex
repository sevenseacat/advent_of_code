defmodule Y2023.Day12 do
  use Advent.Day, no: 12

  def part1(input) do
    input
    |> Task.async_stream(&count_possibilities/1, timeout: :infinity)
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

  defp find_valid_possibilities(state) do
    state = %{
      chars: state.springs,
      expected: state.positions,
      dot: true,
      dash: true
    }

    state
    # |> dbg
    |> next_unknown()
    # |> dbg
    |> add_to_queue(:queue.new())
    |> do_search(0)
  end

  defp add_to_queue(states, queue) do
    Enum.reduce(states, queue, &:queue.in/2)
  end

  defp do_search(queue, count), do: do_move(:queue.out(queue), count)

  defp do_move({:empty, _queue}, count), do: count

  defp do_move({{:value, state}, queue}, count) do
    # dbg(count)

    if state.expected == [] do
      if Enum.any?(state.chars, &(&1 == "#")) do
        do_search(queue, count)
      else
        # IO.puts("match!!!!!! #{inspect(state)}")
        do_search(queue, count + 1)
      end
    else
      state
      # |> dbg
      |> next_unknown()
      # |> dbg
      |> add_to_queue(queue)
      |> do_search(count)
    end
  end

  defp next_unknown(%{chars: [], expected: expected}) when expected != [], do: []

  defp next_unknown(%{chars: chars, expected: expected, dot: dot, dash: dash}) do
    case {hd(chars), dot, dash} do
      {"#", _, false} ->
        []

      {"#", _, true} ->
        taken = Enum.take_while(chars, &(&1 == "#")) |> length()
        group_size = hd(expected)

        cond do
          taken > group_size ->
            []

          taken == group_size ->
            [
              %{
                chars: Enum.drop(chars, taken),
                expected: tl(expected),
                dot: true,
                dash: false
              }
            ]

          taken < group_size ->
            [
              %{
                chars: Enum.drop(chars, taken),
                expected: [group_size - taken | tl(expected)],
                dot: false,
                dash: true
              }
            ]
        end

      {".", true, _dash} ->
        [
          %{
            chars: Enum.drop_while(chars, &(&1 == ".")),
            expected: expected,
            dot: true,
            dash: true
          }
        ]

      {".", false, _dash} ->
        []

      {"?", false, false} ->
        []

      {"?", true, false} ->
        [
          %{
            chars: tl(chars),
            expected: expected,
            dot: true,
            dash: true
          }
        ]

      {"?", false, true} ->
        # dash
        [
          if hd(expected) == 1 do
            %{
              chars: tl(chars),
              expected: tl(expected),
              dot: true,
              dash: false
            }
          else
            %{
              chars: tl(chars),
              expected: [hd(expected) - 1 | tl(expected)],
              dot: false,
              dash: true
            }
          end
        ]

      {"?", true, true} ->
        [
          # dot
          %{
            chars: tl(chars),
            expected: expected,
            dot: true,
            dash: true
          },
          # dash
          if hd(expected) == 1 do
            %{
              chars: tl(chars),
              expected: tl(expected),
              dot: true,
              dash: false
            }
          else
            %{
              chars: tl(chars),
              expected: [hd(expected) - 1 | tl(expected)],
              dot: false,
              dash: true
            }
          end
        ]
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
  # def part2_verify, do: input() |> parse_input() |> part2()
end
