defmodule Advent do
  # http://www.petecorey.com/blog/2018/11/12/permutations-with-and-without-repetition-in-elixir/
  def permutations([], _), do: [[]]
  def permutations(_list, 0), do: [[]]

  def permutations(list, k) do
    for head <- list, tail <- permutations(list -- [head], k - 1), do: [head | tail]
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
end
