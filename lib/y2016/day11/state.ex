defmodule Y2016.Day11.State do
  alias Y2016.Day11.{State, Floor, Elevator}
  defstruct floors: [], elevator: 1

  @winning_floor 4

  def winning_floor, do: @winning_floor

  @doc """
  iex> State.add_components(%State{floors: [
  ...>   %Floor{number: 2, chips: [:s], generators: [:t]},
  ...>   %Floor{number: 1, chips: [:u], generators: [:v]}
  ...> ]}, 1, [:a, :b])
  %State{floors: [
    %Floor{number: 2, chips: [:s], generators: [:t]},
    %Floor{number: 1, chips: [:u, :a, :b], generators: [:v, :a, :b]}
  ]}
  """
  def add_components(%State{floors: floors} = state, number, to_add) do
    floors =
      Enum.map(floors, fn floor ->
        if floor.number == number do
          floor
          |> Map.update!(:chips, fn chips -> chips ++ to_add end)
          |> Map.update!(:generators, fn generators -> generators ++ to_add end)
        else
          floor
        end
      end)

    %{state | floors: floors}
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
  See the test file for a test of this - too big for a doctest.
  """
  def legal_moves(%State{elevator: elevator} = state) do
    Enum.map(Elevator.valid_moves(state), fn new_elevator_pos ->
      get_floor(state, elevator)
      |> Floor.item_combinations()
      |> Stream.map(fn move -> State.apply_move(state, move, new_elevator_pos) end)
      |> Enum.reject(fn state -> !State.legal?(state) end)
    end)
    |> List.flatten()
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
      get_floor(state, old_elevator)
      |> Map.update!(:chips, &(&1 -- chips))
      |> Map.update!(:generators, &(&1 -- generators))

    floors = List.replace_at(floors, floor_index(state, old_elevator), old_floor)

    new_floor =
      get_floor(state, new_elevator)
      |> Map.update!(:chips, &((chips ++ &1) |> Enum.sort()))
      |> Map.update!(:generators, &((generators ++ &1) |> Enum.sort()))

    floors = List.replace_at(floors, floor_index(state, new_elevator), new_floor)

    state
    |> Map.put(:elevator, new_elevator)
    |> Map.put(:floors, floors)
  end

  defp get_floor(%State{floors: floors} = state, floor_no) do
    Enum.at(floors, floor_index(state, floor_no))
  end

  defp floor_index(%State{floors: floors}, floor_no) do
    Enum.find_index(floors, fn floor -> floor.number == floor_no end)
  end
end
