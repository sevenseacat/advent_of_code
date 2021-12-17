defmodule Y2021.Day17 do
  use Advent.Day, no: 17

  @target %{x: {155, 182}, y: {-117, -67}}

  @doc """
  iex> Day17.part1(%{x: {20, 30}, y: {-10, -5}})
  {{6,9}, 45}
  """
  def part1(%{y: {y_min, _}} = target \\ @target) do
    target
    |> possible_velocities()
    |> Enum.map(fn {x, y} -> {{x, y}, find_max_y({x, y}, {0, 0}, y_min)} end)
    |> Enum.max_by(fn {_coord, y} -> y end)
  end

  @doc """
  iex> Day17.part2(%{x: {20, 30}, y: {-10, -5}})
  112
  """
  def part2(target \\ @target) do
    target
    |> possible_velocities()
    |> length
  end

  defp possible_velocities(%{x: {_x_min, x_max} = x_range, y: {y_min, _y_max} = y_range}) do
    for x <- 0..x_max,
        y <- y_min..x_max,
        lands_in_area?({x, y}, {0, 0}, {x_range, y_range}),
        do: {x, y}
  end

  defp find_max_y(velocities, position, max_y) do
    {velocities, {x_pos, y_pos}} = step(velocities, position)

    if y_pos < max_y do
      max_y
    else
      find_max_y(velocities, {x_pos, y_pos}, y_pos)
    end
  end

  def lands_in_area?(
        velocities,
        {x_pos, y_pos} = position,
        {{x_min, x_max}, {y_min, y_max}} = target_area
      ) do
    cond do
      y_pos < y_min ->
        false

      x_pos > x_max ->
        false

      in_range?(x_pos, {x_min, x_max}) && in_range?(y_pos, {y_min, y_max}) ->
        true

      true ->
        {velocities, position} = step(velocities, position)
        lands_in_area?(velocities, position, target_area)
    end
  end

  defp step({x_velocity, y_velocity}, {x_pos, y_pos}) do
    x_pos = x_pos + x_velocity
    y_pos = y_pos + y_velocity

    x_velocity = max(x_velocity - 1, 0)
    y_velocity = y_velocity - 1

    {{x_velocity, y_velocity}, {x_pos, y_pos}}
  end

  defp in_range?(value, {min, max}), do: value >= min && value <= max

  def part1_verify, do: part1() |> elem(1)
  def part2_verify, do: part2()
end
