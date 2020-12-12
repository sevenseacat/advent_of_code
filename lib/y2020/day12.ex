defmodule Y2020.Day12 do
  use Advent.Day, no: 12

  @action_mappings %{
    "N" => :north,
    "S" => :south,
    "E" => :east,
    "W" => :west,
    "L" => :left,
    "R" => :right,
    "F" => :forward
  }

  @left_turns %{
    :east => :north,
    :north => :west,
    :west => :south,
    :south => :east
  }

  @right_turns %{
    :east => :south,
    :south => :west,
    :west => :north,
    :north => :east
  }

  @doc """
  iex> Day12.part1([{:forward, 10}, {:north, 3}, {:forward, 7}, {:right, 90}, {:forward, 11}])
  {%{x: 17, y: -8, facing: :south}, 25}
  """
  def part1(input) do
    state = Enum.reduce(input, %{x: 0, y: 0, facing: :east}, &make_move/2)
    {state, abs(state.x) + abs(state.y)}
  end

  defp make_move({action, value}, state) do
    case action do
      :north -> Map.update!(state, :y, &(&1 + value))
      :south -> Map.update!(state, :y, &(&1 - value))
      :east -> Map.update!(state, :x, &(&1 + value))
      :west -> Map.update!(state, :x, &(&1 - value))
      :left -> Map.put(state, :facing, turn(state, div(value, 90), @left_turns))
      :right -> Map.put(state, :facing, turn(state, div(value, 90), @right_turns))
      :forward -> make_move({Map.get(state, :facing), value}, state)
    end
  end

  defp turn(state, num_turns, turns) do
    Enum.reduce(1..num_turns, Map.get(state, :facing), fn _, acc -> Map.get(turns, acc) end)
  end

  @doc """
  iex> Day12.parse_input("F10\\nN3\\nF7\\nR90\\nF11\\n")
  [{:forward, 10}, {:north, 3}, {:forward, 7}, {:right, 90}, {:forward, 11}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(<<action::binary-size(1), rest::binary>>) do
    {Map.get(@action_mappings, action), String.to_integer(rest)}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
end
