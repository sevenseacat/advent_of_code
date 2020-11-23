defmodule Y2015.Day12 do
  use Advent.Day, no: 12

  @doc """
  iex> Day12.part1("{\\"a\\":2,\\"b\\":4}")
  6

  iex> Day12.part1("{\\"a\\":[-1,1]}")
  0

  iex> Day12.part1("{}")
  0

  iex> Day12.part1("[[[3]]]")
  3
  """
  def part1(input) do
    Regex.scan(~r/-?\d+/, input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  iex> Day12.part2("[1,2,3]")
  6

  iex> Day12.part2("[1,{\\"c\\":\\"red\\",\\"b\\":2},3]")
  4

  iex> Day12.part2("{\\"d\\":\\"red\\",\\"e\\":[1,2,3,4],\\"f\\":5}")
  0

  iex> Day12.part2("[1,\\"red\\",5]")
  6
  """
  def part2(input) do
    input
    |> Jason.decode!()
    |> reject_reds
    |> Jason.encode!()
    |> part1
  end

  defp reject_reds(val) when is_map(val) do
    if Enum.member?(Map.values(val), "red") do
      0
    else
      val
      |> Enum.map(fn {k, v} -> {k, reject_reds(v)} end)
      |> Enum.into(%{})
    end
  end

  defp reject_reds(val) when is_list(val) do
    Enum.map(val, &reject_reds/1)
  end

  defp reject_reds(val), do: val

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
