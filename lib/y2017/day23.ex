defmodule Y2017.Day23 do
  use Advent.Day, no: 23

  def part1(input) do
    cmds = parse_input(input)

    do_part1(
      %{
        cmd_count: length(cmds),
        index: 0,
        data: %{a: 0, b: 0, c: 0, d: 0, e: 0, f: 0, g: 0, h: 0},
        multiple_count: 0
      },
      cmds
    )
  end

  defp do_part1(%{cmd_count: cmd_count, index: index} = state, _) when index >= cmd_count,
    do: state

  defp do_part1(%{index: index} = state, cmds) do
    cmds
    |> Enum.at(index)
    |> run_command(state)
    |> Map.update!(:index, &(&1 + 1))
    |> do_part1(cmds)
  end

  defp run_command({cmd, one, two}, %{data: data} = state) do
    run_parsed_command({cmd, one, val(two, data)}, state)
  end

  defp val(val, _) when is_integer(val), do: val
  defp val(val, data) when is_atom(val), do: Map.fetch!(data, val)

  defp run_parsed_command({:assign, one, two}, state) do
    put_in(state, [:data, one], two)
  end

  defp run_parsed_command({:subtract, one, two}, %{data: data} = state) do
    %{state | data: Map.update!(data, one, &(&1 - two))}
  end

  defp run_parsed_command({:multiply, one, two}, %{data: data} = state) do
    %{state | data: Map.update!(data, one, &(&1 * two)), multiple_count: state.multiple_count + 1}
  end

  defp run_parsed_command({:jump, one, two}, %{index: index, data: data} = state) do
    if val(one, data) == 0 do
      state
    else
      # -1 because we add 1 after in run_command
      %{state | index: index + two - 1}
    end
  end

  def part2 do
    # There are a lot of loops in the puzzle input, and the start of the first one gets hit when:
    # a = 1, b = 106500, c = 123500
    # Running the code from part 1 naively will take forever, because there are three loops nested
    # within each other that do a lot of work.
    # After some manual introspection of the puzzle input, and running parts of the algorithm to see
    # if there was a pattern of register changes that I could extrapolate, I discovered that the
    # outer loop would run 1000 times ((123500 - 106500) / 17), incrementing b (106500) by 17 each
    # time and finally breaking when it reached 123500.
    # When substituting smaller numbers for 123500 and 106500 to see how the final result compared,
    # I noticed that h was being incremented once on every outer loop, unless b was prime.
    # So the answer is 1001 (initial run, plus number of loops), minus the number of prime numbers
    # from b to c that are divisible by 17.
    primes =
      106_500..123_500
      |> Enum.filter(fn num -> rem(num - 106_500, 17) == 0 && is_prime?(num) end)
      |> length

    1001 - primes
  end

  # https://gist.github.com/aditya7iyengar/2487b9ed7f70ed39aa4afec86c730665#file-n_primes_fermat_algorithm-ex
  def is_prime?(n) do
    floored_sqrt =
      :math.sqrt(n)
      |> Float.floor()
      |> round

    !Enum.any?(2..floored_sqrt, &(rem(n, &1) == 0))
  end

  @doc """
  iex> Day23.parse_input("set a 1")
  [{:assign, :a, 1}]

  iex> Day23.parse_input("set b c")
  [{:assign, :b, :c}]

  iex> Day23.parse_input("sub c b")
  [{:subtract, :c, :b}]

  iex> Day23.parse_input("sub d 2")
  [{:subtract, :d, 2}]

  iex> Day23.parse_input("mul a a")
  [{:multiply, :a, :a}]

  iex> Day23.parse_input("mul f 3")
  [{:multiply, :f, 3}]

  iex> Day23.parse_input("jnz a -1")
  [{:jump, :a, -1}]

  iex> Day23.parse_input("jnz -2 h")
  [{:jump, -2, :h}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_line/1)
  end

  defp parse_line([cmd, one, two]) do
    one = parse_value(one)
    two = parse_value(two)

    case cmd do
      "mul" -> {:multiply, one, two}
      "set" -> {:assign, one, two}
      "jnz" -> {:jump, one, two}
      "sub" -> {:subtract, one, two}
    end
  end

  defp parse_value(val) do
    try do
      String.to_integer(val)
    rescue
      ArgumentError -> String.to_atom(val)
    end
  end

  def part1_verify, do: input() |> part1() |> Map.get(:multiple_count)
  def part2_verify, do: part2()
end
