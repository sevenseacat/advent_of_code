defmodule Y2025.Day10 do
  use Advent.Day, no: 10

  def part1(input) do
    input
    |> Advent.pmap(&find_min_presses/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day10.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def find_min_presses(input) do
    initial = Map.new(input.lights, fn {pos, _val} -> {pos, false} end)

    queue =
      queue_next_states(PriorityQueue.new(), input.buttons, %{
        current: initial,
        presses: %{},
        num_presses: 0
      })

    do_search(PriorityQueue.pop(queue), input.lights, input.buttons, MapSet.new([initial]))
  end

  defp queue_next_states(queue, buttons, state) do
    Enum.reduce(buttons, queue, fn button, queue ->
      new_state = push_button(state, button)
      PriorityQueue.push(queue, new_state, new_state.num_presses)
    end)
  end

  defp push_button(state, button) do
    state
    |> Map.update!(:current, fn current ->
      Enum.reduce(button, current, fn pos, acc -> Map.update!(acc, pos, &(!&1)) end)
    end)
    |> Map.update!(:presses, fn presses ->
      Map.update(presses, button, 1, &(&1 + 1))
    end)
    |> Map.update!(:num_presses, &(&1 + 1))
  end

  defp do_search({:empty, _queue}, _graph, _to, _seen),
    do: raise("No valid combination of buttons!")

  defp do_search({{:value, state}, queue}, target, buttons, seen) do
    cond do
      state.current == target ->
        # Winner!
        state.num_presses

      # We've seen this current set of lights before with fewer/same button presses - skip
      MapSet.member?(seen, state.current) ->
        do_search(PriorityQueue.pop(queue), target, buttons, seen)

      true ->
        seen = MapSet.put(seen, state.current)
        queue = queue_next_states(queue, buttons, state)
        do_search(PriorityQueue.pop(queue), target, buttons, seen)
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [lights | rest] = String.split(row, " ")
    [joltage | buttons] = Enum.reverse(rest)

    %{
      lights: parse_lights(lights),
      buttons: parse_buttons(buttons),
      joltage: parse_joltage(joltage)
    }
  end

  defp parse_lights(lights) do
    lights
    |> String.slice(1..-2//1)
    |> String.graphemes()
    |> Enum.reduce({0, %{}}, fn char, {index, acc} ->
      acc = Map.put(acc, index, char == "#")
      {index + 1, acc}
    end)
    |> elem(1)
  end

  defp parse_buttons(buttons) do
    buttons
    |> Enum.reverse()
    |> Enum.map(&parse_num_string/1)
  end

  defp parse_joltage(joltage) do
    joltage
    |> parse_num_string()
    |> Enum.reduce({0, %{}}, fn num, {index, acc} ->
      acc = Map.put(acc, index, num)
      {index + 1, acc}
    end)
    |> elem(1)
  end

  defp parse_num_string(string) do
    string
    |> String.slice(1..-2//1)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
