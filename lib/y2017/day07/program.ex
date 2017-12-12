defmodule Y2017.Day07.Program do
  defstruct name: nil, weight: 0, holding: []

  def find(name, programs) do
    Enum.find(programs, &(&1.name == name))
  end

  def held_by_noone?(program, programs) do
    !Enum.any?(programs, fn p -> Enum.member?(p.holding, program.name) end)
  end
end
