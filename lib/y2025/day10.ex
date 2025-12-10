defmodule Y2025.Day10 do
  use Advent.Day, no: 10

  def part1(input) do
    press_fn = fn val -> !val end
    check_fn = fn _state, _target -> false end

    input
    |> Advent.pmap(fn row ->
      initial = Map.new(row.lights, fn {pos, _val} -> {pos, false} end)
      find_min_presses(row, initial, row.lights, press_fn, check_fn)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    press_fn = fn val -> val + 1 end

    check_fn = fn state, target ->
      Enum.any?(state.current, fn {pos, val} -> val > target[pos] end)
    end

    input
    |> Advent.pmap(
      fn row ->
        initial = Map.new(row.lights, fn {pos, _val} -> {pos, 0} end)
        find_min_presses(row, initial, row.joltage, press_fn, check_fn)
      end,
      timeout: 60000
    )
    |> Enum.sum()
  end

  def find_min_presses(input, initial, target, press_fn, check_fn) do
    queue =
      queue_next_states(PriorityQueue.new(), input.buttons, press_fn, %{
        current: initial,
        presses: 0
      })

    do_search(
      PriorityQueue.pop(queue),
      target,
      input.buttons,
      press_fn,
      check_fn,
      MapSet.new([initial])
    )
  end

  defp queue_next_states(queue, buttons, press_fn, state) do
    Enum.reduce(buttons, queue, fn button, queue ->
      new_state = push_button(state, press_fn, button)
      PriorityQueue.push(queue, new_state, new_state.presses)
    end)
  end

  defp push_button(state, func, button) do
    state
    |> Map.update!(:current, fn current ->
      Enum.reduce(button, current, fn pos, acc -> Map.update!(acc, pos, &func.(&1)) end)
    end)
    |> Map.update!(:presses, &(&1 + 1))
  end

  defp do_search({:empty, _queue}, target, _buttons, _press_fn, _check_fn, seen) do
    raise "No valid state found for #{inspect(target)}: seen #{inspect(seen)}"
  end

  defp do_search({{:value, state}, queue}, target, buttons, press_fn, check_fn, seen) do
    cond do
      state.current == target ->
        # Winner!
        state.presses

      # We've seen this current set of lights before with fewer/same button presses - skip
      MapSet.member?(seen, state.current) || check_fn.(state, target) ->
        do_search(PriorityQueue.pop(queue), target, buttons, press_fn, check_fn, seen)

      true ->
        seen = MapSet.put(seen, state.current)
        queue = queue_next_states(queue, buttons, press_fn, state)
        do_search(PriorityQueue.pop(queue), target, buttons, press_fn, check_fn, seen)
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
