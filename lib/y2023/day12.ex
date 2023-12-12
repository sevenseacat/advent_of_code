defmodule Y2023.Day12 do
  use Advent.Day, no: 12

  def part1(input) do
    input
    |> Task.async_stream(&count_possibilities/1, timeout: :infinity)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(&unfold/1)
    |> part1()
  end

  defp unfold(%{springs: springs, positions: positions}, count \\ 5) do
    springs = List.duplicate(springs, count) |> Enum.intersperse("?") |> List.flatten()
    positions = List.duplicate(positions, count) |> List.flatten()
    %{springs: springs, positions: positions}
  end

  defp count_possibilities(%{springs: springs} = row) do
    if "?" in springs do
      find_valid_possibilities(row)
    else
      1
    end
  end

  defp find_valid_possibilities(%{positions: positions} = state) do
    {full, partial} = position_regex(positions)
    {full, partial} = {~r/^\.*#{full}$/, ~r/^\.*#{partial}$/}
    state = Map.put(state, :character, 0)

    do_search(
      add_to_queue(PriorityQueue.new(), next_spring(state, partial)),
      {full, partial},
      0
    )
  end

  defp add_to_queue(queue, states) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, state, state.character)
    end)
  end

  defp do_search(queue, regex, count), do: do_move(PriorityQueue.pop(queue), regex, count)

  defp do_move({:empty, _queue}, _regex, count), do: count

  defp do_move({{:value, state}, queue}, {full, partial} = regex, count) do
    if Enum.any?(state.springs, &(&1 == "?")) do
      do_search(add_to_queue(queue, next_spring(state, partial)), regex, count)
    else
      if Regex.match?(full, Enum.join(state.springs)) do
        do_search(queue, regex, count + 1)
      else
        do_search(queue, regex, count)
      end
    end
  end

  defp next_spring(%{springs: springs, character: character} = state, regex) do
    if Enum.at(springs, character) == "?" do
      [".", "#"]
      |> Enum.map(&List.replace_at(springs, character, &1))
      |> Enum.filter(fn springs ->
        {check, _} = Enum.split(springs, character + 1)
        Regex.match?(regex, Enum.join(check))
      end)
      |> Enum.map(fn springs ->
        %{state | springs: springs, character: character + 1}
      end)
    else
      next_spring(%{state | character: character + 1}, regex)
    end
  end

  # Turn the list of positions into a regex string
  # eg. 1,1,3 becomes \#{1}\.+\#{1}\.+\#{3}
  defp position_regex(positions) do
    partial =
      positions
      |> Enum.map(&"(\#{1,#{&1}}")
      |> Enum.intersperse("(\\.+")
      |> Enum.concat(["\\.*"])
      |> Enum.concat(List.duplicate("|)", 2 * length(positions) - 1))
      |> Enum.join()

    full =
      positions
      |> Enum.map(&"\#{#{&1}}")
      |> Enum.intersperse("\\.+")
      |> Enum.concat(["\\.*"])
      |> Enum.join()

    {full, partial}
  end

  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [springs, positions] = String.split(row, " ")

      %{
        springs: String.graphemes(springs),
        positions: String.split(positions, ",") |> Enum.map(&String.to_integer/1)
      }
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
