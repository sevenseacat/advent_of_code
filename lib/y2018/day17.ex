defmodule Y2018.Day17 do
  use Advent.Day, no: 17

  @doc """
  iex> File.read!("test/y2018/input/day17/part1.txt") |> Day17.part1()
  57
  """
  def part1(input) do
    input = parse_input(input)
    {_max_x, max_y} = input |> Map.get(:clay) |> Enum.max_by(fn {_, y} -> y end)

    field = run_water(input, {500, 0}, max_y)

    MapSet.union(field.water, field.touched)
    |> MapSet.size()
  end

  defp run_water(field, from, max_y) do
    {field, settled} = drip(field, from, max_y)

    if settled do
      run_water(field, from, max_y)
    else
      field
    end
  end

  @doc """
  iex> File.read!("test/y2018/input/day17/part1.txt") |> Day17.parse_input() |> Day17.drip({500, 0}) |> Map.delete(:clay)
  %{
    touched: MapSet.new([{500, 0}, {500, 1}, {500, 2}, {500, 3}, {500, 4}, {500, 5}, {500, 6},
    {499, 6}, {498, 6}, {497, 6}]),
    water: MapSet.new([{496, 6}])
  }
  """
  def drip(field, {_, max_y}, max_y), do: {field, false}

  def drip(field, {x, y}, max_y, direction \\ :down) do
    field = Map.update!(field, :touched, fn touched -> MapSet.put(touched, {x, y}) end)

    if permeable?(field, {x, y + 1}) do
      drip(field, {x, y + 1}, max_y)
    else
      if Enum.member?([:down, :left], direction) && permeable?(field, {x - 1, y}) do
        drip(field, {x - 1, y}, max_y, :left)
      else
        if permeable?(field, {x + 1, y}) do
          drip(field, {x + 1, y}, max_y, :right)
        else
          {Map.update!(field, :water, fn water -> MapSet.put(water, {x, y}) end), true}
        end
      end
    end
  end

  defp permeable?(field, coord) do
    !MapSet.member?(field.clay, coord) && !MapSet.member?(field.water, coord)
  end

  @doc """
  iex> File.read!("test/y2018/input/day17/part1.txt") |> Day17.parse_input()
  %{
    clay: MapSet.new([{506, 1}, {495, 2}, {498, 2}, {506, 2}, {495, 3}, {498, 3},
    {501, 3}, {495, 4}, {498, 4}, {501, 4}, {495, 5}, {501, 5}, {495, 6},
    {501, 6}, {495, 7}, {496, 7}, {497, 7}, {498, 7}, {499, 7}, {500, 7},
    {501, 7}, {498, 10}, {504, 10}, {498, 11}, {504, 11}, {498, 12}, {504, 12},
    {498, 13}, {499, 13}, {500, 13}, {501, 13}, {502, 13}, {503, 13}, {504, 13}]),
    touched: MapSet.new(),
    water: MapSet.new()
  }
  """
  def parse_input(input) do
    clay =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_row/1)
      |> Enum.reduce(MapSet.new(), &to_clay_field/2)

    %{clay: clay, touched: MapSet.new(), water: MapSet.new()}
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
