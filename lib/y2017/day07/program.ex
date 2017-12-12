defmodule Y2017.Day07.Program do
  alias __MODULE__

  defstruct name: nil, weight: 0, holding: [], stack_weight: 0

  def find(name, programs) do
    Enum.find(programs, &(&1.name == name))
  end

  def held_by_noone?(program, programs) do
    !Enum.any?(programs, fn p -> Enum.member?(p.holding, program.name) end)
  end

  def unbalanced_child_of(program, programs) do
    case balanced?(program, programs) do
      true ->
        nil

      false ->
        children = program_refs(program.holding, programs)
        Enum.find(children, &odd_stack_weight(&1, children))
    end
  end

  # A program is balanced if all of the programs it directly holds have the same stack weight.
  def balanced?(%Program{holding: []}, _), do: true

  def balanced?(%Program{holding: holding}, programs) do
    weights =
      program_refs(holding, programs)
      |> Enum.map(&Map.get(&1, :stack_weight))
      |> Enum.uniq()

    length(weights) == 1
  end

  def program_refs(names, programs) do
    Enum.map(names, &find(&1, programs))
  end

  def siblings(program, programs) do
    programs
    |> Enum.find(&Enum.member?(&1.holding, program.name))
    |> Map.get(:holding)
    |> Enum.reject(&(&1 == program.name))
    |> program_refs(programs)
  end

  defp odd_stack_weight(program, programs) do
    Enum.count(programs, &(&1.stack_weight == program.stack_weight)) == 1
  end
end
