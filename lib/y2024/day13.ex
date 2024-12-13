defmodule Y2024.Day13 do
  use Advent.Day, no: 13

  @doc """
  iex> Day13.part1([
  ...>   %{buttons: %{a: %{x: 94, y: 34, cost: 3}, b: %{x: 22, y: 67, cost: 1}},
  ...>     prize: %{x: 8400, y: 5400}}
  ...> ])
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

  @doc """
  iex> Day13.part2([
  ...>   %{buttons: %{a: %{x: 26, y: 66, cost: 3}, b: %{x: 67, y: 21, cost: 1}},
  ...>     prize: %{x: 10000000012748, y: 10000000012176}}
  ...> ])
  459236326669
  """
  def part2(machines) do
    machines
    |> Enum.map(&find_solution/1)
    |> Enum.reduce(0, fn
      %{a: a, b: b}, acc -> acc + a.tokens + b.tokens
      nil, acc -> acc
    end)
  end

  @doc """
  iex> Day13.find_solution(%{buttons: %{a: %{x: 94, y: 34, cost: 3}, b: %{x: 22, y: 67, cost: 1}}, prize: %{x: 8400, y: 5400}})
  %{a: %{presses: 80, tokens: 240}, b: %{presses: 40, tokens: 40}}
  """
  def find_solution(%{buttons: %{a: button_a, b: button_b}, prize: prize}) do
    # There are two simultaneous equations that need solving = flip the
    # button formulas we have to solve for a and b.
    a = %{one: button_a.x * button_b.cost, two: button_a.y * button_b.cost}
    b = %{one: button_b.x * button_a.cost, two: button_b.y * button_a.cost}
    c = %{one: prize.x, two: prize.y}

    a_presses = (b.two * c.one - b.one * c.two) / (b.two * a.one - b.one * a.two)

    # The last part should really be b.one but doesn't need the cost factor applied
    b_presses = (a.one * trunc(a_presses) - c.one) / (-1 * button_b.x)

    # Fractional values aren't valid - you can't press a button 0.5 times
    if a_presses == trunc(a_presses) && b_presses == trunc(b_presses) do
      %{
        a: %{presses: trunc(a_presses), tokens: trunc(a_presses) * button_a.cost},
        b: %{presses: trunc(b_presses), tokens: trunc(b_presses) * button_b.cost}
      }
    else
      nil
    end
  end

  @doc """
  iex> Day13.parse_input("Button A: X+94, Y+34\\nButton B: X+22, Y+67\\nPrize: X=8400, Y=5400", 0)
  [%{buttons: %{a: %{x: 94, y: 34, cost: 3}, b: %{x: 22, y: 67, cost: 1}}, prize: %{x: 8400, y: 5400}}]
  """
  def parse_input(input, offset) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn machine ->
      [a, b, prize] = String.split(machine, "\n", trim: true)

      %{
        buttons: %{a: parse_button(a, 3), b: parse_button(b, 1)},
        prize: parse_prize(prize, offset)
      }
    end)
  end

  defp parse_button(string, cost) do
    <<"Button ", _::binary-1, ": X+", x::binary-2, ", Y+", y::binary-2>> = string
    %{cost: cost, x: String.to_integer(x), y: String.to_integer(y)}
  end

  defp parse_prize(string, offset) do
    [[x], [y]] = Regex.scan(~r/\d+/, string)
    %{x: String.to_integer(x) + offset, y: String.to_integer(y) + offset}
  end

  def part1_verify, do: input() |> parse_input(0) |> part1()
  def part2_verify, do: input() |> parse_input(10_000_000_000_000) |> part2()
end
