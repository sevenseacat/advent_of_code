defmodule Y2018.Day07 do
  use Advent.Day, no: 7

  @doc """
  iex> Day07.part1(Day07.sample_input)
  "CABDFE"
  """
  def part1(input) do
    input = to_dependency_list(input)

    start = find_next(input) |> hd

    do_part1(input, start, [])
    |> Enum.reverse()
    |> List.to_string()
  end

  @doc """
  iex> Day07.part2(Day07.sample_input, 2, 0)
  {"CABFDE", 15}
  """
  def part2(input, count \\ 5, delay \\ 60) do
    # IO.puts(" ")

    do_part2(%{
      todo: to_dependency_list(input),
      workers: Enum.map(1..count, fn _ -> %{doing: nil, wait: 0} end),
      delay: delay,
      done: [],
      # First tick is tick 0.
      time: -1
    })
  end

  defp do_part2(%{todo: todo, time: time, done: done, workers: workers} = data) do
    # debug(data)

    case map_size(todo) == 0 && all_workers_idle?(workers) do
      true ->
        {done |> Enum.reverse() |> List.to_string(), time}

      false ->
        tick(data) |> do_part2
    end
  end

  defp all_workers_idle?(workers) do
    Enum.all?(workers, fn %{doing: doing} -> doing == nil end)
  end

  def tick(%{workers: workers} = data) do
    data =
      workers
      |> Enum.with_index()
      # Let idle workers grab work first.
      |> Enum.sort_by(fn {%{doing: doing}, _} -> doing == nil end)
      |> Enum.reduce(data, fn worker, data ->
        work(worker, data)
      end)

    Map.update!(data, :time, &(&1 + 1))
  end

  defp work({%{doing: doing, wait: wait} = worker, index}, data) do
    {worker, data} =
      if ready_for_work?(worker) do
        # Can do stuff!
        # Shove what it was working on in done if anything
        data = mark_as_done(data, doing)

        # What's next?
        case find_next(data[:todo]) do
          [] ->
            # Nothing - we're now idle.
            {%{doing: nil, wait: 0}, data}

          [next | _rest] ->
            # Something!
            {
              # New worker with this something.
              %{doing: next, wait: get_wait(next, data[:delay])},

              # Remove this something from the todo list so the next worker doesn't try to do it too.
              Map.update!(data, :todo, fn old_data -> remove_letter(old_data, next) end)
            }
        end
      else
        # Keep waiting...
        {%{doing: doing, wait: max(wait - 1, 0)}, data}
      end

    Map.update!(data, :workers, fn old_workers ->
      List.replace_at(old_workers, index, worker)
    end)
  end

  defp mark_as_done(data, nil), do: data

  defp mark_as_done(data, doing) do
    data
    |> Map.update!(:done, &[doing | &1])
    |> Map.update!(:todo, fn todo -> clear_dependencies(todo, doing) end)
  end

  defp ready_for_work?(%{doing: doing, wait: wait}) do
    doing == nil || (doing != nil && wait - 1 == 0)
  end

  defp do_part1(input, letter, seen) do
    # This letter is seen - mark it as so and remove it from all of the dependency lists.
    seen = [letter | seen]
    input = clear_dependencies(input, letter) |> remove_letter(letter)
    next = find_next(input)

    case next do
      [] -> seen
      [x | _rest] -> do_part1(input, x, seen)
    end
  end

  defp clear_dependencies(input, letter) do
    input
    |> Enum.map(fn {x, list} -> {x, Enum.reject(list, &(&1 == letter))} end)
    |> Enum.into(%{})
  end

  defp remove_letter(input, letter) do
    input
    |> Enum.reject(fn {x, _} -> x == letter end)
    |> Enum.into(%{})
  end

  defp get_wait(letter, delay) do
    (String.to_charlist(letter) |> hd) + delay - 64
  end

  @doc """
  iex> Day07.to_dependency_list(Day07.sample_input)
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

  def debug(%{todo: todo, time: time, workers: workers}) do
    time = String.pad_leading("#{time}", 4, " ")

    workers =
      Enum.map(workers, fn %{doing: doing, wait: wait} ->
        "#{doing || " "} (#{String.pad_leading("#{wait}", 2)})     "
      end)

    todo = Enum.map(todo, fn {x, list} -> "#{x}: #{list}, " end)

    IO.puts("#{time}:    #{workers}   #{todo}")
  end

  def sample_input do
    [{"A", "C"}, {"F", "C"}, {"B", "A"}, {"D", "A"}, {"E", "B"}, {"E", "D"}, {"E", "F"}]
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
