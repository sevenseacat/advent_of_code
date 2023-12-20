defmodule Y2023.Day20 do
  use Advent.Day, no: 20

  def part1(modules, count \\ 1000) do
    Enum.reduce(1..count, {modules, %{high: 0, low: 0}}, fn _count, {modules, pulses} ->
      :queue.new()
      |> add_to_queue([{"broadcaster", :low, :button}])
      |> send_pulse(modules, pulses)
    end)
    |> elem(1)
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp add_to_queue(queue, items) do
    Enum.reduce(items, queue, fn item, queue ->
      :queue.in(item, queue)
    end)
  end

  defp send_pulse(queue, modules, pulses) do
    do_send_pulse(:queue.out(queue), modules, pulses)
  end

  defp do_send_pulse({:empty, _queue}, modules, pulses), do: {modules, pulses}

  defp do_send_pulse({{:value, {to_name, type, from_name}}, queue}, modules, pulses) do
    # IO.puts("#{from_name} --#{type}--> #{to_name}")
    pulses = Map.update!(pulses, type, &(&1 + 1))

    case Map.fetch(modules, to_name) do
      :error ->
        # "testing purposes"
        send_pulse(queue, modules, pulses)

      {:ok, to} ->
        case to.type do
          :forward ->
            queue = add_to_queue(queue, Enum.map(to.outputs, &{&1, type, to_name}))
            send_pulse(queue, modules, pulses)

          :flipflop ->
            if type == :high do
              # Nothing happens
              send_pulse(queue, modules, pulses)
            else
              to = Map.put(to, :status, toggle(to.status))
              modules = Map.put(modules, to_name, to)

              queue =
                add_to_queue(queue, Enum.map(to.outputs, &{&1, pulse_type(to.status), to_name}))

              send_pulse(queue, modules, pulses)
            end

          :conjunction ->
            to = Map.update!(to, :received, fn r -> Map.replace!(r, from_name, type) end)

            next_pulse =
              if Enum.all?(to.received, fn {_name, last} -> last == :high end) do
                :low
              else
                :high
              end

            modules = Map.put(modules, to_name, to)
            queue = add_to_queue(queue, Enum.map(to.outputs, &{&1, next_pulse, to_name}))

            send_pulse(queue, modules, pulses)
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

        {name, Map.put(data, :received, Map.new(in_data))}
      end)
      |> Map.new()

    Map.merge(output, conjunctions)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.values() |> Enum.product()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
