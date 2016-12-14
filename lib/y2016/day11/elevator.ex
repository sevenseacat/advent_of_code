defmodule Y2016.Day11.Elevator do
  alias Y2016.Day11.State

  @doc """
  iex> Elevator.valid_moves(%State{elevator: 1, floors: [
  ...>  %Floor{number: 1}, %Floor{number: 2}]})
  [2]

  iex> Elevator.valid_moves(%State{elevator: 2, floors: [
  ...>  %Floor{number: 1}, %Floor{number: 2}]})
  [1]

  iex> Elevator.valid_moves(%State{elevator: 2, floors: [
  ...>  %Floor{number: 1}, %Floor{number: 2},
  ...>  %Floor{number: 3}]})
  [1, 3]
  """
  def valid_moves(%State{floors: floors, elevator: elevator}) do
    [elevator + 1, elevator - 1]
    |> Enum.filter(fn floor -> Enum.any?(floors, &(&1.number == floor)) end)
  end
end
