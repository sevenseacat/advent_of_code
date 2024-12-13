defmodule Y2024.Day13 do
  use Advent.Day, no: 13

  @doc """
  iex> Day13.part1([%{buttons: %{a: %{x: 94, y: 34, cost: 3}, b: %{x: 22, y: 67, cost: 1}}, prize: %{x: 8400, y: 5400}}])
  280
  """
  def part1(machines) do
    machines
    |> Enum.map(&find_solution/1)
    |> Enum.reduce(0, fn
      %{a: a, b: b}, acc -> acc + a.tokens + b.tokens
      nil, acc -> acc
    end)
  end

  # @doc """
  # iex> Day13.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day13.find_solution(%{buttons: %{a: %{x: 94, y: 34, cost: 3}, b: %{x: 22, y: 67, cost: 1}}, prize: %{x: 8400, y: 5400}})
  %{a: %{presses: 80, tokens: 240}, b: %{presses: 40, tokens: 40}}
  """
  def find_solution(%{buttons: %{a: a, b: b}, prize: prize}) do
    a_presses = Enum.min([100, div(prize.x, a.x), div(prize.y, a.y)])
    b_presses = Enum.min([100, div(prize.x, b.x), div(prize.y, b.y)])

    result =
      for(
        a_press <- 0..a_presses,
        b_press <- 0..b_presses,
        do: {a_press, b_press, a.cost * a_press + b.cost * b_press}
      )
      |> Enum.sort_by(fn {_, _, cost} -> cost end)
      |> Enum.find(fn {a_press, b_press, _cost} ->
        a_press * a.x + b_press * b.x == prize.x && a_press * a.y + b_press * b.y == prize.y
      end)

    if result do
      %{
        a: %{tokens: a.cost * elem(result, 0), presses: elem(result, 0)},
        b: %{tokens: b.cost * elem(result, 1), presses: elem(result, 1)}
      }
    end
  end

  @doc """
  iex> Day13.parse_input("Button A: X+94, Y+34\\nButton B: X+22, Y+67\\nPrize: X=8400, Y=5400")
  [%{buttons: %{a: %{x: 94, y: 34, cost: 3}, b: %{x: 22, y: 67, cost: 1}}, prize: %{x: 8400, y: 5400}}]
  """
  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn machine ->
      [a, b, prize] = String.split(machine, "\n", trim: true)
      %{buttons: %{a: parse_button(a, 3), b: parse_button(b, 1)}, prize: parse_prize(prize)}
    end)
  end

  defp parse_button(string, cost) do
    <<"Button ", _::binary-1, ": X+", x::binary-2, ", Y+", y::binary-2>> = string
    %{cost: cost, x: String.to_integer(x), y: String.to_integer(y)}
  end

  defp parse_prize(string) do
    [[x], [y]] = Regex.scan(~r/\d+/, string)
    %{x: String.to_integer(x), y: String.to_integer(y)}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
