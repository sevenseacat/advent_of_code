defmodule Y2018.Day20 do
  use Advent.Day, no: 20

  @doc """
  iex> Day20.part1("^WNE$")
  3

  iex> Day20.part1("^ENWWW(NEEE|SSE(EE|N))$")
  10

  iex> Day20.part1("^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$")
  18

  iex> Day20.part1("^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$")
  23

  iex> Day20.part1("^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$")
  31
  """
  def part1(input) do
    input
    |> generate_maze
    |> Enum.max_by(fn {_coord, moves} -> moves end)
    |> elem(1)
  end

  def part2(input) do
    input
    |> generate_maze
    |> Enum.filter(fn {_coord, moves} -> moves >= 1000 end)
    |> length
  end

  defp generate_maze(input) do
    ["^" | code] = input |> String.trim() |> String.graphemes()
    run_regex(code, %{}, {0, 0}, [], 1)
  end

  def run_regex(["$"], map, _coord, [], _count), do: map

  def run_regex(["(" | moves], map, coord, stack, count) do
    run_regex(moves, map, coord, [{coord, count} | stack], count)
  end

  def run_regex(["|" | moves], map, _coord, [{back_to, count} | stack], _count) do
    run_regex(moves, map, back_to, [{back_to, count} | stack], count)
  end

  def run_regex([")" | moves], map, _coord, [{back_to, count} | stack], _count) do
    run_regex(moves, map, back_to, stack, count)
  end

  def run_regex([move | moves], map, coord, stack, count) do
    new_coord = make_move(move, coord)
    map = Map.update(map, new_coord, count, &min(count, &1))
    run_regex(moves, map, new_coord, stack, count + 1)
  end

  defp make_move("W", {x, y}), do: {x - 1, y}
  defp make_move("E", {x, y}), do: {x + 1, y}
  defp make_move("S", {x, y}), do: {x, y - 1}
  defp make_move("N", {x, y}), do: {x, y + 1}

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
