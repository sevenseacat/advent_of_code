defmodule Y2016.Day11.State do
  alias Y2016.Day11.{State, Floor}
  defstruct floors: [], elevator: 1

  @winning_floor 4

  def winning_floor, do: @winning_floor

  def initial do
    Code.eval_file("lib/y2016/input/day11.txt") |> elem(0)
  end

  @doc """
  iex> State.legal?(%State{floors: [%Floor{number: 1, chips: [:s], generators: [:s]}]})
  true

  iex> State.legal?(%State{floors: [%Floor{number: 1, chips: [:s, :r], generators: [:s]}]})
  false # R chip is fried by S generator

  iex> State.legal?(%State{floors: [%Floor{number: 1, chips: [:s], generators: [:s, :r]}]})
  true
  """
  def legal?(%State{floors: floors}) do
    Enum.all?(floors, &Floor.legal?/1)
  end

  @doc """
  iex> State.winning?(%State{elevator: 1, floors: [%Floor{number: 4, chips: [:s], generators: [:s, :r]}]})
  false

  iex> State.winning?(%State{elevator: 4, floors: [
  ...>  %Floor{number: 4, chips: [:r, :s], generators: [:s, :r]},
  ...>  %Floor{number: 3, chips: [], generators: []}
  ...> ]})
  true

  iex> State.winning?(%State{elevator: 1, floors: [
  ...>  %Floor{number: 4, chips: [:r, :c], generators: [:s, :r]},
  ...>  %Floor{number: 3, chips: [], generators: []}
  ...> ]})
  false
  """
  def winning?(%State{elevator: elevator}) when elevator != @winning_floor, do: false

  def winning?(%State{floors: floors}) do
    Enum.all?(floors, &Floor.winning?/1)
  end

  @doc """
  TODO: The old floor/new floor stuff is a bit icky.

  iex> State.apply_move(%State{elevator: 2, floors: [
  ...>  %Floor{number: 1, chips: [:a], generators: []},
  ...>  %Floor{number: 2, chips: [:b, :c], generators: [:c, :d]},
  ...>  %Floor{number: 3, chips: [:e], generators: [:e]}
  ...> ]}, %{chips: [:c], generators: [:d]}, 3)
  %State{elevator: 3, floors: [
    %Floor{number: 1, chips: [:a], generators: []},
    %Floor{number: 2, chips: [:b], generators: [:c]},
    %Floor{number: 3, chips: [:c, :e], generators: [:d, :e]}
  ]}
  """
  def apply_move(
        %State{elevator: old_elevator, floors: floors} = state,
        %{chips: chips, generators: generators},
        new_elevator
      ) do
    old_floor =
      floors
      |> Enum.at(floor_index(state, old_elevator))
      |> Map.update!(:chips, &(&1 -- chips))
      |> Map.update!(:generators, &(&1 -- generators))

    floors = List.replace_at(floors, floor_index(state, old_elevator), old_floor)

    new_floor =
      floors
      |> Enum.at(floor_index(state, new_elevator))
      |> Map.update!(:chips, &(chips ++ &1))
      |> Map.update!(:generators, &(generators ++ &1))

    floors = List.replace_at(floors, floor_index(state, new_elevator), new_floor)

    state
    |> Map.put(:elevator, new_elevator)
    |> Map.put(:floors, floors)
  end

  defp floor_index(%State{floors: floors}, floor_no) do
    Enum.find_index(floors, fn floor -> floor.number == floor_no end)
  end
end
