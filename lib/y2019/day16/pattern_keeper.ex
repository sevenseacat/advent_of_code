defmodule Y2019.Day16.PatternKeeper do
  use GenServer

  @base_pattern [0, 1, 0, -1]

  # Public interface
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_pattern_for_digit(digit) do
    GenServer.call(__MODULE__, {:get_pattern_for_digit, digit})
  end

  # Private callbacks
  def init(:ok), do: {:ok, Map.new()}

  def handle_call({:get_pattern_for_digit, digit}, _from, state) do
    state =
      if Map.has_key?(state, digit) do
        state
      else
        pattern = Enum.flat_map(@base_pattern, fn i -> List.duplicate(i, digit + 1) end)
        Map.put(state, digit, pattern)
      end

    {:reply, Map.get(state, digit), state}
  end
end
