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

  @doc """
  iex> Day12.part2([{"start", "A"}, {"start", "b"}, {"A", "c"}, {"A", "b"}, {"b", "d"}, {"A", "end"}, {"b", "end"}])
  36

  iex> Day12.part2([{"dc", "end"}, {"HN", "start"}, {"start", "kj"}, {"dc", "start"}, {"dc", "HN"}, {"LN", "dc"},
  ...> {"HN", "end"}, {"kj", "sa"}, {"kj", "HN"}, {"kj", "dc"}])
  103

  iex> Day12.part2([{"fs", "end"}, {"he", "DX"}, {"fs", "he"}, {"start", "DX"}, {"pj", "DX"}, {"end", "zg"}, {"zg", "sl"},
  ...> {"zg", "pj"}, {"pj", "he"}, {"RW", "he"}, {"fs", "DX"}, {"pj", "RW"}, {"zg", "RW"}, {"start", "pj"}, {"he", "WI"},
  ...> {"zg", "he"}, {"pj", "fs"}, {"start", "RW"}])
  3509
  """
  def part2(input) do
    input
    |> build_paths(&allow_one_revisit/2)
    |> length
  end

  def build_paths(input, revisiter \\ &allow_no_revisits/2) do
    {start_paths, input} = Enum.split_with(input, fn {a, b} -> a == "start" || b == "start" end)
    start_points = Enum.map(start_paths, fn {a, b} -> if a == "start", do: b, else: a end)

    do_build_paths(input, [{["start"], start_points}], [], [], revisiter)
  end

  defp do_build_paths(_input, [], [], complete, _revisiter), do: complete

  defp do_build_paths(input, [], next_level, complete, revisiter) do
    do_build_paths(input, next_level, [], complete, revisiter)
  end

  defp do_build_paths(input, [{_path, []} | rest], next_level, complete, revisiter) do
    do_build_paths(input, rest, next_level, complete, revisiter)
  end

  defp do_build_paths(
         input,
         [{path, [next_step | rest]} | paths],
         next_level,
         complete,
         revisiter
       ) do
    if next_step == "end" do
      # New complete path!
      do_build_paths(
        input,
        [{path, rest} | paths],
        next_level,
        [Enum.reverse([next_step | path]) | complete],
        revisiter
      )
    else
      # Not a complete path - find the next steps from this cave
      do_build_paths(
        input,
        [{path, rest} | paths],
        [
          {[next_step | path], next_steps(input, next_step, path, revisiter)}
          | next_level
        ],
        complete,
        revisiter
      )
    end
  end

  defp next_steps(input, step, path, revisiter) do
    input
    |> Enum.filter(fn {a, b} -> a == step || b == step end)
    |> Enum.map(fn {a, b} -> if a == step, do: b, else: a end)
    |> Enum.filter(fn next_step -> revisiter.([step | path], next_step) end)
  end

  defp allow_no_revisits(path, next_step) do
    !small_cave?(next_step) || !Enum.member?(path, next_step)
  end

  def allow_one_revisit(path, next_step) do
    if !small_cave?(next_step) do
      true
    else
      next_small_caves =
        [next_step | path]
        |> Enum.filter(&small_cave?/1)
        |> Enum.frequencies()
        |> Enum.filter(fn {_cave, count} -> count >= 2 end)

      # This cave hasn't been visited 3 times, and there's a max of one cave that has been visited twice.
      next_small_caves != [{next_step, 3}] && length(next_small_caves) <= 1
    end
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
  def part2_verify, do: input() |> parse_input() |> part2()
end
