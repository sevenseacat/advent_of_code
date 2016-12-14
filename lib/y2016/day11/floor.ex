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
end
