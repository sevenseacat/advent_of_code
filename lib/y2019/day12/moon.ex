defmodule Y2019.Day12.Moon do
  alias __MODULE__

  defstruct position: {0, 0, 0}, velocity: {0, 0, 0}

  def new(position), do: %Moon{position: position}
  def energy({_, %Moon{position: pos, velocity: vel}}), do: kinetic(pos) * kinetic(vel)
  def kinetic({a, b, c}), do: abs(a) + abs(b) + abs(c)

  def update_velocities([m1, m2], moons) do
    %Moon{position: {x1, y1, z1}, velocity: {a1, b1, c1}} = Map.get(moons, m1)
    %Moon{position: {x2, y2, z2}, velocity: {a2, b2, c2}} = Map.get(moons, m2)

    a1 = compare(x1, x2) + a1
    a2 = compare(x2, x1) + a2
    b1 = compare(y1, y2) + b1
    b2 = compare(y2, y1) + b2
    c1 = compare(z1, z2) + c1
    c2 = compare(z2, z1) + c2

    moons
    |> Map.update!(m1, fn m -> %{m | velocity: {a1, b1, c1}} end)
    |> Map.update!(m2, fn m -> %{m | velocity: {a2, b2, c2}} end)
  end

  defp compare(a, b) when a < b, do: 1
  defp compare(a, b) when a > b, do: -1
  defp compare(a, a), do: 0

  def update_positions(moons) do
    moons
    |> Enum.map(&update_position/1)
    |> Enum.into(%{})
  end

  defp update_position({id, %Moon{position: {x, y, z}, velocity: {a, b, c}}}) do
    {id, %Moon{position: {x + a, y + b, z + c}, velocity: {a, b, c}}}
  end
end
