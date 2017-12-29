defmodule Y2017.Day20.Particle do
  alias __MODULE__

  defstruct id: nil, position: nil, velocity: nil, acceleration: nil

  def manhattan_acceleration(%Particle{acceleration: {x, y, z}}) do
    abs(x) + abs(y) + abs(z)
  end

  @doc """
  iex> Particle.move(%Particle{id: 0, position: {3, 0, 0}, velocity: {2, 0, 0}, acceleration: {-1, 0, 0}})
  %Particle{id: 0, position: {4, 0, 0}, velocity: {1, 0, 0}, acceleration: {-1, 0, 0}}
  """
  def move(
        %Particle{position: {x1, y1, z1}, velocity: {x2, y2, z2}, acceleration: {x3, y3, z3}} =
          particle
      ) do
    {x1, x2, x3} = move_axis(x1, x2, x3)
    {y1, y2, y3} = move_axis(y1, y2, y3)
    {z1, z2, z3} = move_axis(z1, z2, z3)
    %{particle | position: {x1, y1, z1}, velocity: {x2, y2, z2}, acceleration: {x3, y3, z3}}
  end

  defp move_axis(position, velocity, acceleration) do
    {position + (velocity + acceleration), velocity + acceleration, acceleration}
  end
end
