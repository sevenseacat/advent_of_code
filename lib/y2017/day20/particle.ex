defmodule Y2017.Day20.Particle do
  alias __MODULE__

  defstruct id: nil, position: nil, velocity: nil, acceleration: nil

  def manhattan_acceleration(%Particle{acceleration: {x, y, z}}) do
    abs(x) + abs(y) + abs(z)
  end
end
