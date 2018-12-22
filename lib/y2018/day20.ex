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
    ["^" | code] = input |> String.trim() |> String.graphemes()

    code
    |> generate_all_paths
    |> Enum.reduce(%{}, fn path, acc -> do_part1(path, acc, {0, 0}, 1) end)
    |> Enum.max_by(fn {_coord, moves} -> moves end)
    |> elem(1)
  end

  def generate_all_paths(list, paths \\ [[]])

  def generate_all_paths(["$"], paths) do
    paths
    |> Enum.uniq()
  end

  def generate_all_paths([char | rest], paths) when char in ["|", ")"] do
    generate_all_paths(rest, paths)
  end

  def generate_all_paths(["(" | rest], paths) do
    {new_paths, rest} = get_sub_paths(rest, paths, [])
    generate_all_paths(rest, new_paths)
  end

  def generate_all_paths([char | rest], paths) do
    # IO.inspect(char, label: "processing")
    # This is a list of single-character binaries, eg. ["W", "N", "(", "E", "|", ")", "$"]
    paths = Enum.map(paths, fn path -> path ++ [char] end)
    generate_all_paths(rest, paths)
  end

  defp get_sub_paths(list, orig_paths, all_paths) do
    # Branching! Read until a |
    # IO.puts("---")
    # IO.inspect(orig_paths, label: "paths to be suffixed")
    # IO.inspect(all_paths)
    # IO.inspect(list, label: "to be read")

    case Enum.split_while(list, fn char -> !Enum.member?(["|", "(", ")"], char) end) do
      {first, ["|", ")" | rest]} ->
        # IO.puts("found an empty option!")
        new_paths = Enum.map(orig_paths, fn path -> path ++ first end)
        {orig_paths ++ new_paths ++ all_paths, rest}

      {first, ["|" | rest]} ->
        new_paths = Enum.map(orig_paths, fn path -> path ++ first end)
        get_sub_paths(rest, orig_paths, new_paths ++ all_paths)

      {first, ["(" | rest]} ->
        new_paths = Enum.map(orig_paths, fn path -> path ++ first end)
        {paths, rest} = get_sub_paths(rest, new_paths, new_paths ++ all_paths)
        get_sub_paths(rest, orig_paths, paths)

      {last, [")" | rest]} ->
        new_paths = Enum.map(orig_paths, fn path -> path ++ last end)
        {new_paths ++ all_paths, rest}
    end
  end

  defp do_part1([], map, _coord, _count), do: map

  defp do_part1([move | moves], map, coord, count) do
    new_coord = make_move(move, coord)
    map = Map.update(map, new_coord, count, &min(count, &1))
    do_part1(moves, map, new_coord, count + 1)
  end

  defp make_move("W", {x, y}), do: {x - 1, y}
  defp make_move("E", {x, y}), do: {x + 1, y}
  defp make_move("S", {x, y}), do: {x, y - 1}
  defp make_move("N", {x, y}), do: {x, y + 1}
end
