defmodule Advent do
  # http://www.petecorey.com/blog/2018/11/12/permutations-with-and-without-repetition-in-elixir/
  def permutations([], _), do: [[]]
  def permutations(_list, 0), do: [[]]

  def permutations(list, k) do
    for head <- list, tail <- permutations(list -- [head], k - 1), do: [head | tail]
  end

  def permutations_with_repetitions([], _), do: [[]]
  def permutations_with_repetitions(_list, 0), do: [[]]

  def permutations_with_repetitions(list, k) do
    for head <- list, tail <- permutations_with_repetitions(list, k - 1), do: [head | tail]
  end

  def full_permutations(list) when is_list(list) do
    permutations(list, length(list))
  end

  # Combinations don't involve any kind of order.
  # https://stackoverflow.com/a/30587756/560215
  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []

  def combinations([x | xs], n) do
    for(y <- combinations(xs, n - 1), do: [x | y]) ++ combinations(xs, n)
  end

  # https://stackoverflow.com/a/42887944/560215
  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  # https://stackoverflow.com/q/147515/560215
  def lowest_common_multiple([one, two]) do
    div(one * two, Integer.gcd(one, two))
  end

  def lowest_common_multiple([one | rest]) do
    lowest_common_multiple([one, lowest_common_multiple(rest)])
  end

  def pmap(collection, func, opts \\ []) do
    collection
    |> Task.async_stream(&func.(&1), opts)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  # https://kmrakibulislam.wordpress.com/2015/10/25/find-common-items-in-two-lists-in-elixir/
  def common_elements([one]), do: one

  def common_elements([one | rest]) do
    two = common_elements(rest)
    one -- one -- two
  end
end
