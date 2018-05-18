defmodule Y2017.Day22 do
  use Advent.Day, no: 22

  def part1(data, iterations) do
    data
    |> parse_input()
    |> do_parts(default_state(iterations))
  end

  def part2(data, iterations) do
    data
    |> parse_input()
    |> do_parts(%{default_state(iterations) | level: :evolved})
  end

  defp default_state(iterations) do
    %{
      position: {0, 0},
      facing: :up,
      infection_count: 0,
      iteration_no: 0,
      max_iterations: iterations,
      level: :naive
    }
  end

  defp do_parts(_, %{infection_count: count, iteration_no: iteration, max_iterations: iteration}) do
    count
  end

  defp do_parts(data, %{position: position, facing: facing, level: level} = state) do
    infected = infection_status(data, position)
    new_facing = turn(facing, infected)

    state =
      state
      |> Map.update!(:iteration_no, &(&1 + 1))
      |> Map.put(:facing, new_facing)
      |> Map.update!(:infection_count, &update_infection_count(&1, infected, level))
      |> Map.update!(:position, fn pos -> move(pos, new_facing) end)

    data
    |> Map.update(position, infect(:clean, level), &infect(&1, level))
    |> do_parts(state)
  end

  def parse_input(data) do
    data = String.split(data) |> Enum.with_index()
    centre = hd(data) |> elem(0) |> String.length() |> div(2)

    Enum.reduce(data, %{}, fn {row, y}, acc ->
      chars = row |> String.codepoints() |> Enum.with_index()

      Enum.reduce(chars, acc, fn {col, x}, acc2 ->
        Map.put(acc2, {x - centre, centre - y}, input_char_to_status(col))
      end)
    end)
  end

  defp input_char_to_status("#"), do: :infected
  defp input_char_to_status("."), do: :clean

  defp infection_status(data, position), do: Map.get(data, position, :clean)

  defp turn(:up, :infected), do: :right
  defp turn(:up, :clean), do: :left
  defp turn(:up, :flagged), do: :down

  defp turn(:left, :infected), do: :up
  defp turn(:left, :clean), do: :down
  defp turn(:left, :flagged), do: :right

  defp turn(:down, :infected), do: :left
  defp turn(:down, :clean), do: :right
  defp turn(:down, :flagged), do: :up

  defp turn(:right, :infected), do: :down
  defp turn(:right, :clean), do: :up
  defp turn(:right, :flagged), do: :left

  defp turn(x, :weakened), do: x

  defp move({x, y}, :up), do: {x, y + 1}
  defp move({x, y}, :down), do: {x, y - 1}
  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :right), do: {x + 1, y}

  defp infect(:clean, :naive), do: :infected
  defp infect(:infected, :naive), do: :clean

  defp infect(:clean, :evolved), do: :weakened
  defp infect(:weakened, :evolved), do: :infected
  defp infect(:infected, :evolved), do: :flagged
  defp infect(:flagged, :evolved), do: :clean

  defp update_infection_count(count, :clean, :naive), do: count + 1
  defp update_infection_count(count, :weakened, :evolved), do: count + 1
  defp update_infection_count(count, _, _), do: count

  defp display_grid(data, pos) do
    for i <- -4..4,
        j <- -4..4 do
      var =
        case Map.get(data, {j, i}) do
          :infected -> "#"
          :flagged -> "F"
          :weakened -> "W"
        end

      if pos == {j, i} do
        "[#{var}]"
      else
        " #{var} "
      end
    end
    |> Enum.chunk_every(9)
    |> Enum.reverse()
  end

  def part1_verify, do: input() |> part1(10000)
  def part2_verify, do: input() |> part2(10_000_000)
end
