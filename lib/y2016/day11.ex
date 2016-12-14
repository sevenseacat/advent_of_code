defmodule Y2016.Day11 do
  use Advent.Day, no: 11

  @winning_floor :f4

  @doc """
  See the test file for tests - too long to use doctests for.
  """
  def legal_moves({positions, _elevator} = state) do
    # One or two chips/generators can be moved from one floor to the previous/next
    Enum.map(possible_elevator_positions(state), fn new_elevator ->
      Enum.map(possible_item_combinations(state), fn items_to_move ->
        {[{new_elevator, {[], []}}], new_elevator}
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&legal_state?/1)
  end

  def initial_state do
    Code.eval_file("lib/y2016/input/day11.txt") |> elem(0)
  end

  @doc """
  iex> Day11.legal_state?({[f1: {[:s], [:s]}], :f1})
  true

  iex> Day11.legal_state?({[f1: {[:s, :r], [:s]}], :f1})
  false # r chip is fried

  iex> Day11.legal_state?({[f1: {[:s], [:s, :r]}], :f1})
  true
  """
  def legal_state?({positions, _elevator}) do
    Enum.all?(positions, &legal_floor_state?/1)
  end

  @doc """
  iex> Day11.winning_state?({[f4: {[:s], [:s, :r]}], :f1})
  false

  iex> Day11.winning_state?({[f4: {[:r, :s], [:s, :r]}, f3: {[], []}], :f4})
  true

  iex> Day11.winning_state?({[f4: {[:r, :c], [:s, :r]}, f3: {[], []}], :f1})
  false
  """
  def winning_state?({_positions, elevator}) when elevator != @winning_floor, do: false

  def winning_state?({positions, _elevator}) do
    Enum.all?(positions, &winning_floor_state?/1)
  end

  def legal_floor_state?({_floor, {_chips, []}}), do: true

  def legal_floor_state?({_floor, {chips, generators}}) do
    chips
    |> Enum.all?(fn chip -> Enum.member?(generators, chip) end)
  end

  def winning_floor_state?({floor, {chips, generators}}) when floor == @winning_floor do
    Enum.sort(chips) == Enum.sort(generators)
  end

  def winning_floor_state?({floor, {[], []}}) when floor != @winning_floor, do: true
  def winning_floor_state?(_), do: false

  @doc """
  iex> Day11.possible_elevator_positions({[f1: [], f2: []], :f1})
  [:f2]

  iex> Day11.possible_elevator_positions({[f1: [], f2: []], :f2})
  [:f1]

  iex> Day11.possible_elevator_positions({[f1: [], f2: [], f3: []], :f2})
  [:f1, :f3]
  """
  def possible_elevator_positions({positions, current_floor}) do
    number = Atom.to_string(current_floor) |> String.last() |> String.to_integer()

    ["f#{number - 1}", "f#{number + 1}"]
    |> Enum.map(&String.to_atom/1)
    |> Enum.filter(fn floor -> positions[floor] end)
  end

  @doc """
  iex> Day11.possible_item_combinations({[f1: {[:r], [:s]}, f2: {[:t, :u], [:v, :w]}], :f2}) |> Enum.sort
  [[:t], [:t, :u], [:t, :v], [:t, :w], [:u], [:u, :v], [:u, :w], [:v], [:v, :w], [:w]]
  """
  def possible_item_combinations({positions, current_floor}) do
    {chips, generators} = positions[current_floor]

    (Enum.map(chips, &{:chip, &1}) ++ Enum.map(generators, &{:generator, &1}))
    |> permutations_of_size(2)
    |> Enum.map(&Enum.sort/1)
    |> IO.inspect()
    |> Enum.map(fn list -> Enum.group_by(list, fn {type, value} -> value end) end)
    |> Enum.uniq()
  end

  defp permutations_of_size(_, 0), do: []

  defp permutations_of_size(floor_data, size) do
    Advent.permutations(floor_data, size) ++ permutations_of_size(floor_data, size - 1)
  end
end
