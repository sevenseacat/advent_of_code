defmodule Y2021.Day12 do
  use Advent.Day, no: 12

  @doc """
  iex> Day12.part1([{"start", "A"}, {"start", "b"}, {"A", "c"}, {"A", "b"}, {"b", "d"}, {"A", "end"}, {"b", "end"}])
  10

  iex> Day12.part1([{"dc", "end"}, {"HN", "start"}, {"start", "kj"}, {"dc", "start"}, {"dc", "HN"}, {"LN", "dc"},
  ...> {"HN", "end"}, {"kj", "sa"}, {"kj", "HN"}, {"kj", "dc"}])
  19

  iex> Day12.part1([{"fs", "end"}, {"he", "DX"}, {"fs", "he"}, {"start", "DX"}, {"pj", "DX"}, {"end", "zg"}, {"zg", "sl"},
  ...> {"zg", "pj"}, {"pj", "he"}, {"RW", "he"}, {"fs", "DX"}, {"pj", "RW"}, {"zg", "RW"}, {"start", "pj"}, {"he", "WI"},
  ...> {"zg", "he"}, {"pj", "fs"}, {"start", "RW"}])
  226
  """
  def part1(input) do
    input
    |> build_paths()
    |> length
  end

  def build_paths(input) do
    {start_paths, input} = Enum.split_with(input, fn {a, b} -> a == "start" || b == "start" end)
    start_points = Enum.map(start_paths, fn {a, b} -> if a == "start", do: b, else: a end)

    do_build_paths(input, [{["start"], start_points}], [], [])
  end

  defp do_build_paths(_input, [], [], complete), do: complete

  defp do_build_paths(input, [], next_level, complete) do
    do_build_paths(input, next_level, [], complete)
  end

  defp do_build_paths(input, [{_path, []} | rest], next_level, complete) do
    do_build_paths(input, rest, next_level, complete)
  end

  defp do_build_paths(input, [{path, [next_step | rest]} | paths], next_level, complete) do
    if next_step == "end" do
      # New complete path!
      do_build_paths(input, [{path, rest} | paths], next_level, [
        Enum.reverse([next_step | path]) | complete
      ])
    else
      # Not a complete path - find the next steps from this cave
      do_build_paths(
        input,
        [{path, rest} | paths],
        [{[next_step | path], next_steps(input, next_step, path)} | next_level],
        complete
      )
    end
  end

  defp next_steps(input, step, path) do
    input
    |> Enum.filter(fn {a, b} -> a == step || b == step end)
    |> Enum.map(fn {a, b} -> if a == step, do: b, else: a end)
    |> Enum.reject(fn step -> small_cave?(step) && Enum.member?(path, step) end)
  end

  defp small_cave?(cave), do: cave != "start" && cave != "end" && String.downcase(cave) == cave

  @doc """
  iex> Day12.parse_input("start-A\\nstart-b\\nA-c\\nA-b\\nb-d\\nA-end\\nb-end\\n")
  [{"start", "A"}, {"start", "b"}, {"A", "c"}, {"A", "b"}, {"b", "d"}, {"A", "end"}, {"b", "end"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("-")
      |> List.to_tuple()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
