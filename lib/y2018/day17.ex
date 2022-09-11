defmodule Y2018.Day17 do
  use Advent.Day, no: 17

  alias Y2018.Day17.Ground

  @doc """
  iex> test_data("sample") |> Day17.parse_input |> Day17.part1()
  57
  iex> {from, state} = test_data("sample_picture") |> Day17.parse_picture_input()
  iex> Day17.part1(state, from)
  57
  """
  def part1(state, {from_x, from_y} \\ {500, 0}) do
    {_max_x, max_y} = state |> Map.get(:clay) |> Enum.max_by(fn {_, y} -> y end)
    {:ok, ground} = Ground.init(state)

    run_water(ground, [from_x], {from_y, max_y + 1})
    Ground.count_wet_squares(ground)
  end

  defp run_water(_ground, x, {max_y, max_y}), do: x

  defp run_water(ground, streams, {y, max_y}) do
    new_streams =
      Enum.map(streams, fn stream -> drip(ground, stream, {y, max_y}) end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.reject(fn stream -> stream == nil end)

    run_water(ground, new_streams, {y + 1, max_y})
  end

  def drip(_ground, x, {max_y, max_y}), do: x

  def drip(ground, x, {y, _}) do
    Ground.mark_wet(ground, {x, y})

    if Ground.sand?(ground, {x, y + 1}) do
      # Stream continues down
      x
    else
      # Clay or water. We may fill a clay bucket, or may run over the edge and fall.
      fill_bucket(ground, {x, y}, y + 1)
    end
  end

  defp fill_bucket(ground, {x, y}, max_y) do
    {left_edge, left_state} = check_left(ground, {x, y})
    {right_edge, right_state} = check_right(ground, {x, y})

    if left_state == :clay && right_state == :clay do
      Ground.fill_row(ground, left_edge, right_edge)
      fill_bucket(ground, {x, y - 1}, max_y)
    else
      if left_state == :sand || right_state == :sand do
        Ground.wet_row(ground, left_edge, right_edge)

        acc = []

        acc =
          if left_state == :sand do
            {left_x, left_y} = left_edge
            [run_water(ground, [left_x], {left_y, max_y}) | acc]
          else
            acc
          end

        acc =
          if right_state == :sand do
            {right_x, right_y} = right_edge
            [run_water(ground, [right_x], {right_y, max_y}) | acc]
          else
            acc
          end

        acc
      end
    end
  end

  defp check_left(ground, {x, y}) do
    if Ground.sand?(ground, {x, y + 1}) do
      {{x, y}, :sand}
    else
      if Ground.sand?(ground, {x - 1, y}) do
        check_left(ground, {x - 1, y})
      else
        {{x, y}, :clay}
      end
    end
  end

  defp check_right(ground, {x, y}) do
    if Ground.sand?(ground, {x, y + 1}) do
      # This is the edge.
      {{x, y}, :sand}
    else
      if Ground.sand?(ground, {x + 1, y}) do
        check_right(ground, {x + 1, y})
      else
        {{x, y}, :clay}
      end
    end
  end

  @doc """
  This is just like the normal day 17 sample input, except starting at 0,0 instead of
  494,0.

  iex> test_data("sample_picture") |> Day17.parse_picture_input()
  {{6, 0}, %{
    clay: MapSet.new([{7, 6}, {5, 7}, {10, 12}, {4, 13}, {4, 10}, {2, 7}, {8, 13},
    {6, 13}, {5, 13}, {1, 3}, {7, 4}, {7, 5}, {9, 13}, {7, 7}, {4, 7}, {1, 5},
    {12, 1}, {10, 13}, {3, 7}, {1, 2}, {1, 4}, {6, 7}, {4, 2}, {1, 6}, {4, 11},
    {10, 11}, {4, 12}, {1, 7}, {4, 3}, {10, 10}, {7, 13}, {4, 4}, {12, 2}, {7, 3}]),
    wet: MapSet.new(),
    water: MapSet.new()
  }}
  """
  def parse_picture_input(input) do
    %{"#" => clay, "+" => [{x, y, _}]} =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(&parse_picture_row/1)
      |> List.flatten()
      |> Enum.group_by(fn {_, _, char} -> char end)

    {{x, y},
     %{
       clay: clay |> Enum.map(fn {x, y, _} -> {x, y} end) |> MapSet.new(),
       wet: MapSet.new(),
       water: MapSet.new()
     }}
  end

  defp parse_picture_row({data, row_no}) do
    data
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, col_no} -> {col_no, row_no, char} end)
  end

  @doc """
  iex> test_data("sample") |> Day17.parse_input()
  %{
    clay: MapSet.new([{506, 1}, {495, 2}, {498, 2}, {506, 2}, {495, 3}, {498, 3},
    {501, 3}, {495, 4}, {498, 4}, {501, 4}, {495, 5}, {501, 5}, {495, 6},
    {501, 6}, {495, 7}, {496, 7}, {497, 7}, {498, 7}, {499, 7}, {500, 7},
    {501, 7}, {498, 10}, {504, 10}, {498, 11}, {504, 11}, {498, 12}, {504, 12},
    {498, 13}, {499, 13}, {500, 13}, {501, 13}, {502, 13}, {503, 13}, {504, 13}]),
    wet: MapSet.new(),
    water: MapSet.new()
  }
  """
  def parse_input(input) do
    clay =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_row/1)
      |> Enum.reduce(MapSet.new(), &to_clay_field/2)

    %{clay: clay, wet: MapSet.new(), water: MapSet.new()}
  end

  defp parse_row(row) do
    data =
      Regex.named_captures(
        ~r/(?<axis1>[x|y])=(?<axis1_var>\d+), (?<axis2>[x|y])=(?<axis2_min>\d+)\.\.(?<axis2_max>\d+)/,
        row
      )

    %{}
    |> Map.put(
      String.to_atom(data["axis1"]),
      String.to_integer(data["axis1_var"])..String.to_integer(data["axis1_var"])
    )
    |> Map.put(
      String.to_atom(data["axis2"]),
      String.to_integer(data["axis2_min"])..String.to_integer(data["axis2_max"])
    )
  end

  defp to_clay_field(%{x: x_range, y: y_range}, field) do
    for(x <- x_range, y <- y_range, do: {x, y})
    |> MapSet.new()
    |> MapSet.union(field)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
