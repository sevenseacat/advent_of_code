defmodule Y2017.Day03 do
  use Advent.Day, no: 03

  @initial_move {1, 0}
  @puzzle_input 277_678

  @doc """
  iex> Day03.part1(1)
  0

  iex> Day03.part1(12)
  3

  iex> Day03.part1(23)
  2

  iex> Day03.part1(1024)
  31
  """
  def part1(input) when is_integer(input) do
    input
    |> build_board
    |> calculate_distance
  end

  defp build_board(input) do
    1..input
    |> Enum.reduce({{0, 0}, @initial_move, {1, 1, 1}}, fn num, state ->
      case num == input do
        true -> state
        false -> next_state(state)
      end
    end)
  end

  # progress is the current position in the movement pattern
  # ie. to build the pattern:
  #   17  16  15  14  13
  #   18   5   4   3  12
  #   19   6   1   2  11
  #   20   7   8   9  10
  #   21  22  23---> ...
  # the sequence of moves is like:
  # set 1: 1 move right
  # set 2: 1 move up
  # set 3: 2 moves left
  # set 4: 2 moves down
  # set 5: 3 moves right
  # set 6: 3 moves up
  # ... see where this is going?
  # so a progress state is { set number, # of moves in set, current move # in set }
  defp next_state({current_position, movement_direction, progress}) do
    {new_direction, new_progress} = calculate_move(movement_direction, progress)
    new_position = make_move(current_position, new_direction)

    {new_position, new_direction, new_progress}
  end

  defp calculate_move(direction, {x, y, z}) do
    case y == z do
      true -> {turn(direction), {x + 1, div(x, y), 1}}
      false -> {direction, {x + 1, y, z + 1}}
    end
  end

  defp make_move({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  defp calculate_distance({{x, y}, _, _}), do: abs(x) + abs(y)

  defp turn({1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {1, 0}

  def part1_verify, do: part1(@puzzle_input)
end
