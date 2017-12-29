defmodule Y2017.Day20Test do
  use ExUnit.Case, async: true
  alias Y2017.Day20
  alias Y2017.Day20.Particle
  doctest Day20
  doctest Day20.Particle

  test "verification, part 1", do: assert(Day20.part1_verify() == 258)
  test "verification, part 2", do: assert(Day20.part2_verify() == 707)

  test "ticking from example" do
    initial = [
      %Particle{id: 0, position: {-6, 0, 0}, velocity: {3, 0, 0}, acceleration: {0, 0, 0}},
      %Particle{id: 1, position: {-4, 0, 0}, velocity: {2, 0, 0}, acceleration: {0, 0, 0}},
      %Particle{id: 2, position: {-2, 0, 0}, velocity: {1, 0, 0}, acceleration: {0, 0, 0}},
      %Particle{id: 3, position: {3, 0, 0}, velocity: {-1, 0, 0}, acceleration: {0, 0, 0}}
    ]

    after_one = Day20.tick(initial)

    assert after_one == [
             %Particle{id: 0, position: {-3, 0, 0}, velocity: {3, 0, 0}, acceleration: {0, 0, 0}},
             %Particle{id: 1, position: {-2, 0, 0}, velocity: {2, 0, 0}, acceleration: {0, 0, 0}},
             %Particle{id: 2, position: {-1, 0, 0}, velocity: {1, 0, 0}, acceleration: {0, 0, 0}},
             %Particle{id: 3, position: {2, 0, 0}, velocity: {-1, 0, 0}, acceleration: {0, 0, 0}}
           ]

    after_two = Day20.tick(after_one)

    # Particles 0, 1, and 2 met at {0, 0, 0} and were all destroyed.
    assert after_two == [
             %Particle{id: 3, position: {1, 0, 0}, velocity: {-1, 0, 0}, acceleration: {0, 0, 0}}
           ]
  end
end
