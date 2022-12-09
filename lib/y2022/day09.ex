defmodule Y2022.Day09 do
  use Advent.Day, no: 09

  def part1(input), do: do_parts(input, 2)
  def part2(input), do: do_parts(input, 10)

  def do_parts(input, knot_count) do
    initial = {0, 0}

    Enum.reduce(
      input,
      {List.duplicate(initial, knot_count), MapSet.new([initial])},
      &take_action/2
    )
    |> elem(1)
    |> MapSet.size()
  end

  defp take_action(move, {[head | knots], seen}) do
    new_head = move_head(move, head)
    knots = move_tails([new_head | knots])
    {knots, MapSet.put(seen, List.last(knots))}
  end

  defp move_head(:left, {row, col}), do: {row, col - 1}
  defp move_head(:right, {row, col}), do: {row, col + 1}
  defp move_head(:up, {row, col}), do: {row - 1, col}
  defp move_head(:down, {row, col}), do: {row + 1, col}

  defp move_tails([tail]), do: [tail]

  defp move_tails([{head_row, head_col}, {tail_row, tail_col} | knots]) do
    new_tail =
      if abs(head_row - tail_row) <= 1 && abs(head_col - tail_col) <= 1 do
        # Already touching, don't need to move the tail
        {tail_row, tail_col}
      else
        {offset_row, offset_col} = tail_movement(head_row - tail_row, head_col - tail_col)
        {tail_row + offset_row, tail_col + offset_col}
      end

    [{head_row, head_col} | move_tails([new_tail | knots])]
  end

  # All possible combinations of where a tail should move based on the movement of the head.
  defp tail_movement(0, 2), do: {0, 1}
  defp tail_movement(0, -2), do: {0, -1}
  defp tail_movement(2, 0), do: {1, 0}
  defp tail_movement(-2, 0), do: {-1, 0}
  defp tail_movement(2, 1), do: {1, 1}
  defp tail_movement(-2, 1), do: {-1, 1}
  defp tail_movement(2, -1), do: {1, -1}
  defp tail_movement(-2, -1), do: {-1, -1}
  defp tail_movement(1, 2), do: {1, 1}
  defp tail_movement(1, -2), do: {1, -1}
  defp tail_movement(-1, 2), do: {-1, 1}
  defp tail_movement(-1, -2), do: {-1, -1}

  # If the head is being pulled diagonally, the tail must also move in that direction
  defp tail_movement(-2, -2), do: {-1, -1}
  defp tail_movement(2, -2), do: {1, -1}
  defp tail_movement(-2, 2), do: {-1, 1}
  defp tail_movement(2, 2), do: {1, 1}

  @doc """
  iex> Day09.parse_input("R 4\\nU 4\\nL 3\\nD 1")
  [:right, :right, :right, :right, :up, :up, :up, :up, :left, :left, :left, :down]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&parse_row/1)
  end

  defp parse_row(row) do
    [direction, times] = String.split(row, " ")
    List.duplicate(to_atom(direction), String.to_integer(times))
  end

  defp to_atom("R"), do: :right
  defp to_atom("L"), do: :left
  defp to_atom("U"), do: :up
  defp to_atom("D"), do: :down

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
