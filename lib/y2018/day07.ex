defmodule Y2018.Day07 do
  use Advent.Day, no: 7

  @doc """
  iex> Day07.part1([{"A", "C"}, {"F", "C"}, {"B", "A"}, {"D", "A"}, {"E", "B"}, {"E", "D"}, {"E", "F"}])
  "CABDFE"
  """
  def part1(input) do
    input = to_dependency_list(input)

    start = find_next(input) |> hd

    do_part1(input, start, [])
    |> Enum.reverse()
    |> List.to_string()
  end

  defp do_part1(input, letter, seen) do
    # This letter is seen - mark it as so and remove it from all of the dependency lists.
    seen = [letter | seen]
    input = clear_dependencies(input, letter)
    next = find_next(input)

    case next do
      [] -> seen
      x -> do_part1(input, hd(x), seen)
    end
  end

  defp clear_dependencies(input, letter) do
    input
    |> Enum.map(fn {x, list} -> {x, Enum.reject(list, &(&1 == letter))} end)
    |> Enum.reject(fn {x, _} -> x == letter end)
    |> Enum.into(%{})
  end

  @doc """
  iex> Day07.to_dependency_list([{"A", "C"}, {"F", "C"}, {"B", "A"}, {"D", "A"}, {"E", "B"}, {"E", "D"}, {"E", "F"}])
  %{"A" => ["C"], "B" => ["A"], "C" => [], "D" => ["A"], "E" => ["F", "D", "B"], "F" => ["C"]}
  """
  def to_dependency_list(input) do
    map = letters(input) |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x, []) end)

    input
    |> Enum.reduce(map, fn {x, y}, acc -> Map.update(acc, x, [y], &[y | &1]) end)
  end

  defp find_next(input) do
    input
    |> Stream.filter(fn {_, list} -> list == [] end)
    |> Stream.map(&elem(&1, 0))
    |> Enum.sort()
  end

  def letters(input) do
    input
    |> Enum.reduce([], fn {x, y}, list -> [x, y | list] end)
    |> Enum.uniq()
  end

  @doc """
  iex> Day07.parse_input("Step C must be finished before step A can begin.\\nStep C must be finished before step F can begin.")
  # Can be read as "A depends on C and F depends on C"
  [{"A", "C"}, {"F", "C"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(
         <<"Step ", x::binary-1, " must be finished before step ", y::binary-1, " can begin.">>
       ) do
    {y, x}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
