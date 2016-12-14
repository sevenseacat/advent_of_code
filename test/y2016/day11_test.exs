defmodule Y2016.Day11Test do
  use ExUnit.Case, async: true
  alias Y2016.Day11
  alias Y2016.Day11.{State, Floor}

  doctest Day11
  doctest Day11.State
  doctest Day11.Floor

  test "calculating legal moves for a given state" do
    expected = [
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:s], generators: []},
          %Floor{number: 2, chips: [:r], generators: [:s, :r]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 1,
        floors: [
          %Floor{number: 1, chips: [:r], generators: []},
          %Floor{number: 2, chips: [:s], generators: [:s, :r]},
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
          %Floor{number: 1, chips: [:s, :r], generators: []},
          %Floor{number: 2, chips: [], generators: [:s, :r]},
          %Floor{number: 3, chips: [], generators: []}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:r], generators: [:s, :r]},
          %Floor{number: 3, chips: [:s], generators: []}
        ]
      },
      %State{
        elevator: 3,
        floors: [
          %Floor{number: 1, chips: [], generators: []},
          %Floor{number: 2, chips: [:s], generators: [:s, :r]},
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
          %Floor{number: 2, chips: [], generators: [:s, :r]},
          %Floor{number: 3, chips: [:s, :r], generators: []}
        ]
      }
    ]

    assert Day11.legal_moves(%State{
             elevator: 2,
             floors: [
               %Floor{number: 1, chips: [], generators: []},
               %Floor{number: 2, chips: [:s, :r], generators: [:s, :r]},
               %Floor{number: 3, chips: [], generators: []}
             ]
           }) == expected
  end
end
