defmodule Y2016.Day11Test do
  use ExUnit.Case, async: true
  alias Y2016.Day11
  alias Y2016.Day11.{State, Floor}

  doctest Day11
  doctest Day11.State
  doctest Day11.Floor

  test "verification, part 1", do: assert(Day11.part1_verify() == 37)
  test "verification, part 2", do: assert(Day11.part2_verify() == 61)

  test "calculating legal moves for a given state" do
    expected_states = [
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:s], generators: []},
          %Floor{number: 2, chips: [:r], generators: [:r, :s]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:r], generators: []},
          %Floor{number: 2, chips: [:s], generators: [:r, :s]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:s], generators: [:s]},
          %Floor{number: 2, chips: [:r], generators: [:r]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:r], generators: [:r]},
          %Floor{number: 2, chips: [:s], generators: [:s]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:r, :s], generators: []},
          %Floor{number: 2, chips: [], generators: [:r, :s]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [], generators: [:r, :s]},
          %Floor{number: 2, chips: [:r, :s], generators: []},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:r], generators: [:r, :s]},
          %Floor{number: 3, chips: [:s], generators: []}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:s], generators: [:r, :s]},
          %Floor{number: 3, chips: [:r], generators: []}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:r], generators: [:r]},
          %Floor{number: 3, chips: [:s], generators: [:s]}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:s], generators: [:s]},
          %Floor{number: 3, chips: [:r], generators: [:r]}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [], generators: [:r, :s]},
          %Floor{number: 3, chips: [:r, :s], generators: []}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:r, :s], generators: []},
          %Floor{number: 3, chips: [], generators: [:r, :s]}
        ]
      }
    ]

    actual_states =
      State.legal_moves(%State{
        elevator: 2,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:r, :s], generators: [:r, :s]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      })

    assert length(actual_states) == length(expected_states)

    Enum.each(actual_states, fn state ->
      assert state in expected_states
    end)
  end

  test "running an actual scenario for a given initial state and returning a path length" do
    # This is from the example in the puzzle itself.
    initial_state = %State{
      elevator: 1,
      floors: [
        %Floor{number: 1, chips: [:h, :l], generators: []},
        %Floor{number: 2, chips: [], generators: [:h]},
        %Floor{number: 3, chips: [], generators: [:l]},
        %Floor{number: 4, chips: [], generators: []}
      ],
      types: [:h, :l]
    }

    actual_path = Day11.get_optimal_path(initial_state)
    assert length(actual_path) == 11
  end

  test "state equivalence" do
    state_a = %State{
      elevator: 1,
      floors: [%Floor{number: 1, chips: [:a], generators: [:a]}],
      types: [:a]
    }

    state_b = %State{
      elevator: 1,
      floors: [%Floor{number: 1, chips: [:b], generators: [:b]}],
      types: [:b]
    }

    assert State.normalized(state_a) == State.normalized(state_b)

    state_ab = %State{
      elevator: 1,
      floors: [%Floor{number: 1, chips: [:b, :a], generators: [:a, :b]}],
      types: [:a, :b]
    }

    state_ba = %State{
      elevator: 1,
      floors: [%Floor{number: 1, chips: [:a, :b], generators: [:b, :a]}],
      types: [:a, :b]
    }

    assert State.normalized(state_ab) == State.normalized(state_ba)
  end
end
