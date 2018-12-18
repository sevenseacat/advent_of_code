defmodule Y2018.Day17 do
  use Advent.Day, no: 17

  alias Y2018.Day17.Ground

  @doc """
  iex> File.read!("test/y2018/input/day17/part1.txt") |> Day17.part1()
  57
  """
  def part1(input) do
    state = parse_input(input)
    {_max_x, max_y} = state |> Map.get(:clay) |> Enum.max_by(fn {_, y} -> y end)

    Ground.init(state)
    run_water({500, 0}, max_y, 0)
    Ground.show_state()
    Ground.count_wet_squares()
  end

  defp run_water(from, max_y, count) do
    if drip(from, max_y) do
      IO.inspect(Ground.count_wet_squares())
      run_water(from, max_y, count + 1)
    end
  end

  def drip({_, y}, max_y) when y > max_y do
    false
  end

  def drip({x, y}, max_y) do
    # IO.inspect({x, y})
    Ground.mark_wet({x, y})

    if Ground.permeable?({x, y + 1}) do
      drip({x, y + 1}, max_y)
    else
      # Clay or water. We may fill another row of a clay bucket, or may run over the edge and fall.
      {left_edge, left_state} = check_left({x, y})
      {right_edge, right_state} = check_right({x, y})

      if left_state == :clay && right_state == :clay do
        Ground.fill_row(left_edge, right_edge)
        true
      else
        if left_state == :sand || right_state == :sand do
          Ground.wet_row(left_edge, right_edge)
          left = if left_state == :sand, do: drip(left_edge, max_y), else: false
          right = if right_state == :sand, do: drip(right_edge, max_y), else: false

          left || right
        end
      end
    end
  end

  def check_left({x, y}) do
    if Ground.permeable?({x, y + 1}) do
      {{x, y}, :sand}
    else
      if Ground.permeable?({x - 1, y}) do
        check_left({x - 1, y})
      else
        {{x, y}, :clay}
      end
    end
  end

  def check_right({x, y}) do
    if Ground.permeable?({x, y + 1}) do
      # This is the edge.
      {{x, y}, :sand}
    else
      if Ground.permeable?({x + 1, y}) do
        check_right({x + 1, y})
      else
        {{x, y}, :clay}
      end
    end
  end

  @doc """
  iex> File.read!("test/y2018/input/day17/part1.txt") |> Day17.parse_input()
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
end
