defmodule Y2023.Day20 do
  use Advent.Day, no: 20

  def part1(modules, count \\ 1000) do
    Enum.reduce(1..count, {modules, %{high: 0, low: 0}}, fn count, {modules, pulses} ->
      do_press_button(modules, pulses, count)
    end)
    |> elem(1)
  end

  def part2(modules) do
    # I didn't like this puzzle. It just didn't seem fun to me.
    # The naive approach will never find an answer (I tried it, trust me)
    # So we need to do something different.
    # `rx`'s input is a conjunction module, `kj`
    # All of its inputs need to be high to send out a low.
    # Record when any of its inputs are high
    modules =
      Map.update!(modules, "kj", fn kj ->
        high_seen =
          kj.inputs
          |> Enum.reduce(%{}, fn {key, _val}, acc -> Map.put(acc, key, nil) end)

        Map.put(kj, :high_seen, high_seen)
      end)

    # Highs ocur in cycles - so they will all be high at the product/LCM of
    # the cycles when they are first seen high
    modules
    |> press_button(%{high: 0, low: 0}, 1)
    |> Map.values()
    |> Enum.product()
  end

  defp press_button(modules, pulses, count) do
    if rem(count, 100_000) == 0, do: IO.puts(count)

    {modules, _button_pulses} =
      do_press_button(modules, pulses, count)

    high_seen = Map.fetch!(modules, "kj").high_seen

    if Enum.all?(high_seen, fn {_key, cycle} -> cycle end) do
      high_seen
    else
      press_button(modules, pulses, count + 1)
    end
  end

  defp do_press_button(modules, pulses, count) do
    :queue.new()
    |> add_to_queue([{"broadcaster", :low, :button}])
    |> send_pulse(modules, pulses, count)
  end

  defp add_to_queue(queue, items) do
    Enum.reduce(items, queue, fn item, queue ->
      :queue.in(item, queue)
    end)
  end

  defp send_pulse(queue, modules, pulses, count) do
    do_send_pulse(:queue.out(queue), modules, pulses, count)
  end

  defp do_send_pulse({:empty, _queue}, modules, pulses, _count), do: {modules, pulses}

  defp do_send_pulse({{:value, {to_name, type, from_name}}, queue}, modules, pulses, count) do
    # IO.puts("#{from_name} --#{type}--> #{to_name}")
    pulses = Map.update!(pulses, type, &(&1 + 1))

    case Map.fetch(modules, to_name) do
      :error ->
        send_pulse(queue, modules, pulses, count)

      {:ok, to} ->
        case to.type do
          :forward ->
            queue = add_to_queue(queue, Enum.map(to.outputs, &{&1, type, to_name}))
            send_pulse(queue, modules, pulses, count)

          :flipflop ->
            if type == :high do
              # Nothing happens
              send_pulse(queue, modules, pulses, count)
            else
              to = Map.put(to, :status, toggle(to.status))
              modules = Map.put(modules, to_name, to)

              queue =
                add_to_queue(queue, Enum.map(to.outputs, &{&1, pulse_type(to.status), to_name}))

              send_pulse(queue, modules, pulses, count)
            end

          :conjunction ->
            to = Map.update!(to, :inputs, fn r -> Map.replace!(r, from_name, type) end)

            to =
              if Map.has_key?(to, :high_seen) && type == :high do
                Map.update!(to, :high_seen, fn tracker ->
                  Map.put(tracker, from_name, count)
                end)
              else
                to
              end

            next_pulse =
              if Enum.all?(to.inputs, fn {_name, last} -> last == :high end) do
                :low
              else
                :high
              end

            modules = Map.put(modules, to_name, to)
            queue = add_to_queue(queue, Enum.map(to.outputs, &{&1, next_pulse, to_name}))

            send_pulse(queue, modules, pulses, count)
        end
    end
  end

  defp toggle(:on), do: :off
  defp toggle(:off), do: :on

  defp pulse_type(:on), do: :high
  defp pulse_type(:off), do: :low

  def parse_input(input) do
    output =
      for row <- String.split(input, "\n", trim: true), into: %{} do
        [name | outputs] = String.split(row, [" -> ", ", "])

        {name, type, extra} =
          case String.first(name) do
            "%" ->
              {String.slice(name, 1..100), :flipflop, %{status: :off}}

            "&" ->
              {String.slice(name, 1..100), :conjunction, %{}}

            _ ->
              {name, :forward, %{}}
          end

        {name, Map.merge(%{type: type, outputs: outputs}, extra)}
      end

    # Need to do another pass to record inputs for conjunction modules
    conjunctions =
      output
      |> Enum.filter(fn {_name, %{type: type}} -> type == :conjunction end)
      |> Enum.map(fn {name, data} ->
        in_data =
          Enum.filter(output, fn {_, %{outputs: outputs}} -> name in outputs end)
          |> Enum.map(fn {name, _} -> {name, :low} end)

        {name, Map.put(data, :inputs, Map.new(in_data))}
      end)
      |> Map.new()

    Map.merge(output, conjunctions)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.values() |> Enum.product()
  def part2_verify, do: input() |> parse_input() |> part2()
end
