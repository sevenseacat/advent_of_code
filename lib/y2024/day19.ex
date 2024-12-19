defmodule Y2024.Day19 do
  use Advent.Day, no: 19

  def part1(%{from: from_towels, to: to_towels}) do
    Task.async_stream(to_towels, fn to ->
      ways_to_make(to, from_towels)
    end)
    |> Enum.count(fn {:ok, count} -> count != 0 end)
  end

  def part2(%{from: from_towels, to: to_towels}) do
    Task.async_stream(to_towels, fn to ->
      ways_to_make(to, from_towels)
    end)
    |> Enum.reduce(0, fn {:ok, count}, acc -> acc + count end)
  end

  def ways_to_make(to, from_towels) do
    queue = add_to_queue(PriorityQueue.new(), to)
    find_towel_list(queue, from_towels, %{})
  end

  defp add_to_queue(queue, item) do
    PriorityQueue.push(queue, item, -String.length(item))
  end

  def find_towel_list(queue, from_towels, seen) do
    do_find_towel_list(PriorityQueue.pop(queue), from_towels, seen)
  end

  defp do_find_towel_list({:empty, _queue}, _from_towels, _seen), do: 0

  defp do_find_towel_list({{:value, ""}, _queue}, _from_towels, seen), do: Map.fetch!(seen, "")

  defp do_find_towel_list({{:value, to}, queue}, from_towels, seen) do
    {seen, queue} =
      from_towels
      |> Enum.filter(fn from -> String.starts_with?(to, from) end)
      |> Enum.reduce({seen, queue}, fn from, {seen, queue} ->
        rest = String.slice(to, String.length(from), 1000)
        to_count = Map.get(seen, to, 1)

        if Map.has_key?(seen, rest) do
          {Map.update!(seen, rest, &(&1 + to_count)), queue}
        else
          {Map.put(seen, rest, to_count), add_to_queue(queue, rest)}
        end
      end)

    find_towel_list(queue, from_towels, seen)
  end

  def parse_input(input) do
    [from, to] = String.split(input, "\n\n", trim: true)

    %{
      from: String.split(from, ", "),
      to: String.split(to, "\n", trim: true)
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
