defmodule Y2020.Day08 do
  use Advent.Day, no: 8

  @doc """
  iex> Day08.part1(%{0 => {:noop, 0}, 1 => {:acc, 1}, 2 => {:jmp, 4}, 3 => {:acc, 3}, 4 => {:jmp, -3},
  ...>              5 => {:acc, -99}, 6 => {:acc, 1}, 7 => {:jmp, -4}, 8 => {:acc, 6}})
  {:repeat, 5}
  """
  def part1(input) do
    run_app(input, {0, 0, MapSet.new()})
  end

  defp run_app(input, {pos, val, seen} = state) do
    if MapSet.member?(seen, pos) do
      {:repeat, val}
    else
      process_instruction(input, state)
    end
  end

  defp process_instruction(input, {pos, val, seen} = state) do
    seen = MapSet.put(seen, pos)

    case Map.get(input, pos) do
      nil ->
        {:exit, state}

      {:noop, _val} ->
        run_app(input, {pos + 1, val, seen})

      {:jmp, jmp} ->
        run_app(input, {pos + jmp, val, seen})

      {:acc, acc} ->
        run_app(input, {pos + 1, val + acc, seen})
    end
  end

  @doc """
  iex> Day08.part2(%{0 => {:noop, 0}, 1 => {:acc, 1}, 2 => {:jmp, 4}, 3 => {:acc, 3}, 4 => {:jmp, -3},
  ...>              5 => {:acc, -99}, 6 => {:acc, 1}, 7 => {:jmp, -4}, 8 => {:acc, 6}})
  {:exit, 8}
  """
  def part2(input) do
    input
    |> Map.keys()
    |> Enum.reduce([input], fn pos, acc ->
      case Map.get(input, pos) do
        {:acc, _} -> acc
        {:noop, noop} -> [Map.put(input, pos, {:jmp, noop}) | acc]
        {:jmp, jmp} -> [Map.put(input, pos, {:noop, jmp}) | acc]
      end
    end)
    # One of the inputs will terminate with an {:exit, state} value.
    |> Enum.find_value(fn input ->
      {status, state} = run_app(input, {0, 0, MapSet.new()})
      if status == :exit, do: {status, elem(state, 1)}
    end)
  end

  @doc """
  iex> Day08.parse_input("nop +0\\nacc +1\\njmp -2\\n")
  %{0 => {:noop, 0}, 1 => {:acc, 1}, 2 => {:jmp, -2}}
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(&parse_row/1)
    |> Enum.into(%{})
  end

  defp parse_row({"nop " <> rest, num}), do: {num, {:noop, String.to_integer(rest)}}
  defp parse_row({"acc " <> rest, num}), do: {num, {:acc, String.to_integer(rest)}}
  defp parse_row({"jmp " <> rest, num}), do: {num, {:jmp, String.to_integer(rest)}}

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
