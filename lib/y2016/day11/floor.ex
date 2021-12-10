defmodule Y2016.Day11.Floor do
  alias Y2016.Day11.{State, Floor}
  defstruct number: 0, chips: [], generators: []

  def legal?(%Floor{generators: []}), do: true

  def legal?(%Floor{chips: chips, generators: generators}) do
    Enum.all?(chips, &Enum.member?(generators, &1))
  end

  def winning?(%Floor{number: number, chips: chips, generators: generators}) do
    if number == State.winning_floor() do
      Enum.sort(chips) == Enum.sort(generators)
    else
      Enum.empty?(chips) && Enum.empty?(generators)
    end
  end

  @doc """
  There's got to be a quicker way to do this. But for now, it works.
  Generates a list of all the options available for moving from a given floor.

  iex> Floor.item_combinations(%Floor{chips: [:t, :u], generators: [:v, :w]})
  [
    %{chips: [:t, :u], generators: []},
    %{chips: [:t], generators: [:v]},
    %{chips: [:t], generators: [:w]},
    %{chips: [:u], generators: [:v]},
    %{chips: [:u], generators: [:w]},
    %{chips: [], generators: [:v, :w]},
    %{chips: [:t], generators: []},
    %{chips: [:u], generators: []},
    %{chips: [], generators: [:v]},
    %{chips: [], generators: [:w]}
  ]
  """
  def item_combinations(floor) do
    floor
    |> object_permutations(2)
    |> Stream.map(&Enum.sort/1)
    |> Stream.map(&Enum.reverse/1)
    |> Stream.uniq()
    |> Enum.map(fn list ->
      Enum.reduce(list, %{chips: [], generators: []}, fn {type, value}, acc ->
        Map.update!(acc, type, &[value | &1])
      end)
    end)
  end

  defp object_permutations(_, 0), do: []

  defp object_permutations(floor, max_size) do
    Advent.permutations(combine_objects(floor), max_size) ++
      object_permutations(floor, max_size - 1)
  end

  @doc """
  Because the same named object can be either a chip or a generator, when we want to
  generate permutations, we need to differentiate them somehow - do so by turning each
  name into a tuple of type and name
  """
  def combine_objects(%Floor{chips: chips, generators: generators}) do
    Enum.map(chips, &{:chips, &1}) ++ Enum.map(generators, &{:generators, &1})
  end
end
