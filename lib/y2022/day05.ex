defmodule Y2022.Day05 do
  use Advent.Day, no: 05

  #             [M] [S] [S]
  #         [M] [N] [L] [T] [Q]
  # [G]     [P] [C] [F] [G] [T]
  # [B]     [J] [D] [P] [V] [F] [F]
  # [D]     [D] [G] [C] [Z] [H] [B] [G]
  # [C] [G] [Q] [L] [N] [D] [M] [D] [Q]
  # [P] [V] [S] [S] [B] [B] [Z] [M] [C]
  # [R] [H] [N] [P] [J] [Q] [B] [C] [F]
  #  1   2   3   4   5   6   7   8   9

  @stacks %{
    1 => ~c"RPCDBG",
    2 => ~c"HVG",
    3 => ~c"NSQDJPM",
    4 => ~c"PSLGDCNM",
    5 => ~c"JBNCPFLS",
    6 => ~c"QBDZVGTS",
    7 => ~c"BZMHFTQ",
    8 => ~c"CMDBF",
    9 => ~c"FCQ"
  }

  def part1(input, stacks \\ @stacks), do: do_parts(input, stacks, &mover_9000/3)
  def part2(input, stacks \\ @stacks), do: do_parts(input, stacks, &mover_9001/3)

  defp do_parts(input, stacks, mover_fn) do
    stacks = build_queues(stacks)

    stacks =
      input
      |> Enum.reduce(stacks, fn move, stacks -> move(move, stacks, mover_fn) end)
      |> Enum.reduce(%{}, fn {num, stack}, acc -> Map.put(acc, num, :queue.to_list(stack)) end)

    value = Enum.map(stacks, fn {_num, stack} -> List.last(stack) end)
    {stacks, value}
  end

  def move(%{count: count, from: from_id, to: to_id}, stacks, mover_fn) do
    from_stack = Map.fetch!(stacks, from_id)
    to_stack = Map.fetch!(stacks, to_id)

    {from_stack, to_stack} = mover_fn.(from_stack, to_stack, count)

    %{stacks | from_id => from_stack, to_id => to_stack}
  end

  defp mover_9000(from, to, count) do
    Enum.reduce(1..count, {from, to}, fn _x, {f, t} ->
      {{:value, crate}, f} = :queue.out_r(f)
      {f, :queue.in(crate, t)}
    end)
  end

  defp mover_9001(from, to, count) do
    {from, to_move} =
      Enum.reduce(1..count, {from, []}, fn _x, {f, pile} ->
        {{:value, crate}, f} = :queue.out_r(f)
        {f, [crate | pile]}
      end)

    to =
      Enum.reduce(to_move, to, fn crate, t ->
        :queue.in(crate, t)
      end)

    {from, to}
  end

  defp build_queues(stacks) do
    Enum.reduce(stacks, %{}, fn {num, crates}, acc ->
      Map.put(acc, num, :queue.from_list(crates))
    end)
  end

  @doc """
  iex> Day05.parse_input("move 1 from 7 to 4\\nmove 3 from 4 to 7\\n")
  [%{count: 1, from: 7, to: 4}, %{count: 3, from: 4, to: 7}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string ->
      [count, from, to] =
        Regex.run(~r/move (\d+) from (\d+) to (\d+)/, string, capture: :all_but_first)

      %{
        count: String.to_integer(count),
        from: String.to_integer(from),
        to: String.to_integer(to)
      }
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1(@stacks) |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2(@stacks) |> elem(1)
end
