defmodule Y2016.Day02 do
  use Advent.Day, no: 2

  @starting_position 5
  @grid_size 3

  @doc """
  iex> Day02.bathroom_code(["ULL", "RRDDD", "LURDL", "UUUUD"])
  1985
  """
  def bathroom_code(input) do
    input
    |> Enum.map_reduce(@starting_position, fn move, position ->
      position =
        move
        |> String.to_charlist()
        |> calculate_digit(position)

      {position, position}
    end)
    # We don't care about the final accumulator value
    |> elem(0)
    |> Enum.map(&Integer.to_string(&1))
    |> List.to_string()
    |> String.to_integer()
  end

  def parse_input do
    input() |> String.split()
  end

  defp calculate_digit([], position), do: position

  defp calculate_digit([head | tail], position) do
    calculate_digit(tail, move(head, position))
  end

  defp move(direction, position) do
    position
    |> to_grid_pos
    |> make_move(direction)
    |> from_grid_pos
  end

  @doc """
  Convert a number to its position on the bathroom keypad.
  [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]

  iex> Day02.to_grid_pos(6)
  {2, 1}

  iex> Day02.to_grid_pos(1)
  {0, 0}
  """
  def to_grid_pos(position) do
    {rem(position - 1, @grid_size), div(position - 1, @grid_size)}
  end

  @doc """
  iex> Day02.from_grid_pos({0, 0})
  1

  iex> Day02.from_grid_pos({2, 1})
  6
  """
  def from_grid_pos({x, y}), do: y * @grid_size + x + 1

  def make_move({x, y}, ?L), do: {max(x - 1, 0), y}
  def make_move({x, y}, ?R), do: {min(x + 1, @grid_size - 1), y}
  def make_move({x, y}, ?U), do: {x, max(y - 1, 0)}
  def make_move({x, y}, ?D), do: {x, min(y + 1, @grid_size - 1)}

  def part1_verify, do: parse_input() |> bathroom_code()
end
