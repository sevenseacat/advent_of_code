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
end
