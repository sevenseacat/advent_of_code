defmodule Y2019.Day16.PatternKeeper do
  @base_pattern [0, 1, 0, -1]

  # Public interface
  def new, do: :ets.new(:patterns, [:public])

  def get_pattern_for_digit(state, digit) do
    case :ets.match_object(state, {digit, :_}) do
      [{^digit, pattern}] ->
        pattern

      [] ->
        pattern = Enum.flat_map(@base_pattern, fn i -> List.duplicate(i, digit + 1) end)
        :ets.insert(state, {digit, pattern})
        pattern
    end
  end
end
