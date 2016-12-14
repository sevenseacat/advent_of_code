defmodule Y2016.Day11.Floor do
  alias Y2016.Day11.{State, Floor}
  defstruct number: 0, chips: [], generators: []

  def legal?(%Floor{generators: []}), do: true

  def legal?(%Floor{chips: chips, generators: generators}) do
    Enum.all?(chips, &Enum.member?(generators, &1))
  end

  def winning?(%Floor{number: number, chips: chips, generators: generators}) do
    case number == State.winning_floor() do
      true -> Enum.sort(chips) == Enum.sort(generators)
      false -> Enum.empty?(chips) && Enum.empty?(generators)
    end
  end

  @doc """
  iex> Floor.item_combinations(%Floor{chips: [:t, :u], generators: [:v, :w]}) |> Enum.sort
  [[:t], [:t, :u], [:t, :v], [:t, :w], [:u], [:u, :v], [:u, :w], [:v], [:v, :w], [:w]]
  """
  def item_combinations(floor) do
    floor
    |> object_permutations(2)
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(fn list -> Enum.group_by(list, fn {type, value} -> type end) end)
    |> Enum.uniq()
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
  defp combine_objects(%Floor{chips: chips, generators: generators}) do
    Enum.map(chips, &{:chips, &1}) ++ Enum.map(generators, &{:generators, &1})
  end
end
