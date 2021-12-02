defmodule Y2021.Day02 do
  use Advent.Day, no: 2

  @doc """
  iex> Day02.part1([{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}])
  %{horizontal: 15, depth: 10}
  """
  def part1(input) do
    Enum.reduce(input, %{horizontal: 0, depth: 0}, &move/2)
  end

  defp move({:up, num}, position), do: Map.update!(position, :depth, &(&1 - num))
  defp move({:down, num}, position), do: Map.update!(position, :depth, &(&1 + num))
  defp move({:forward, num}, position), do: Map.update!(position, :horizontal, &(&1 + num))

  @doc """
  iex> Day02.parse_input("forward 5\\ndown 5\\nforward 8\\nup 3\\ndown 8\\nforward 2")
  [{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}]
  """
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_command/1)
  end

  defp parse_command(cmd) do
    [direction, num] = String.split(cmd, " ")
    {String.to_atom(direction), String.to_integer(num)}
  end

  def part1_verify do
    %{horizontal: h, depth: d} = input() |> parse_input() |> part1()
    h * d
  end
end
