defmodule Y2022.Day10 do
  use Advent.Day, no: 10

  def part1(input) do
    input
    |> run_cmds()
    |> to_signal_strength()
  end

  def part2(input) do
    input
    |> run_cmds()
    |> to_crt_display()
  end

  defp run_cmds(cmds, state \\ [1])
  defp run_cmds([], state), do: Enum.reverse(tl(state))

  defp run_cmds([cmd | rest], state) do
    run_cmds(rest, run_cmd(cmd, state) ++ state)
  end

  defp run_cmd({:noop, 1}, [h | _t]), do: [h]

  defp run_cmd({{:add, val}, count}, [h | _t]) when count > 0 do
    [h + val | List.duplicate(h, count - 1)]
  end

  defp to_signal_strength(list) do
    first = Enum.take(list, 20) |> List.last() |> Kernel.*(20)

    rest =
      list
      |> Enum.drop(19)
      # This always includes the first element then takes every 40th after that, eg, indexes [0, 40, etc.]
      # We want the 40th, eg. index 39, so shove another element on the front (to be index 0) and
      # then we can drop it afterwards
      |> Enum.take_every(40)
      |> tl()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {val, offset}, acc -> ((offset + 1) * 40 + 20) * val + acc end)

    first + rest
  end

  defp to_crt_display(list) do
    list
    |> Enum.with_index()
    |> Enum.map(&to_crt_char/1)
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp to_crt_char({x_val, index}) do
    if rem(index, 40) in (x_val - 1)..(x_val + 1), do: "#", else: "."
  end

  @doc """
  iex> Day10.parse_input("noop\\naddx 3\\naddx -5\\n")
  [{:noop, 1}, {{:add, 3}, 2}, {{:add, -5}, 2}]
  """

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_cmd/1)
  end

  defp parse_cmd("noop"), do: {:noop, 1}
  defp parse_cmd(<<"addx "::binary, rest::binary>>), do: {{:add, String.to_integer(rest)}, 2}

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
