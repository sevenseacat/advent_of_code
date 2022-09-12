defmodule Y2018.Day21 do
  use Advent.Day, no: 21

  alias Y2018.{Day16, Day19}

  def part1(input) do
    # More reverse engineering! My favorite!
    # Not much code needed for this one - just a copy of part 1 of day 19, with the first
    # register tweaked.
    # I also added a command counter to day 19's code, as we're gonna need it to actually solve
    # the problem.

    # So. What does this code actually do?
    # Let's run it with 0 in register 0, see what it does (even though it says it never halts.)
    # After a few ticks, R1 is 65536 (2^8), R2 is ticking up by 1s and 256s, R4 is incrementing
    # for each tick of R2.
    # When R2's ticks get to 257 (256+1?) and 65792 (R1+256?), things happen.
    # R3 moves to R1. (986758? What's the meaning of it?)
    # Ticking of R2 starts again, and continues until 3855 (3854+1?) and 986880 (122 more than R1?)
    # How do all these numbers relate?
    # Look at another loop.... R1 is now 7969776, R2 ticks to 31132 and 7969792 - first tick of
    # R2 more than R1.
    # Next loop, R1 is 14675073, R2 ticks to 57325 and 14675200.
    # R1 actually shifts to eq R4, not R2 - unless R4 is zero, then it takes R3.
    # R3 seems to be the key, I don't know what pattern it's following.
    # And I still don't know what the code is trying to *do*, or why it doesn't complete...
    # (Is the command counter relevant? Given it's new.)
    # R3's initial value is 9450265 - that's from the puzzle input itself.
    # Then it goes 622763013235 -> 9532531 ??
    # Puzzle input also says multiply by 65899 and band 16777215. OK.

    # So what happens if we change R0? Run again with it set to 1.
    # Everything looks the same.
    # Change it to something wacky - 42.
    # Everything still looks the same.
    # Let's look at the input. Where is R0 used?
    # eqrr 3 0 4
    # So passing if R3 is equal to R0.
    # First time this command is run, R3 is 986758.... that can't be the answer, can it?
    # > That's the right answer! You are one gold star closer to fixing the time stream.
    # Oh dammit.
    %{ip: ip, commands: commands} = Day19.parse_input(input)
    Day19.run_commands({986_758, 0, 0, 0, 0, 0}, ip, commands)
  end

  def part2(input) do
    # So there's going to be a loop in the R3 value over time, and we want the value of
    # the very last one before the loop starts again. That will execute the most
    # instructions.
    %{ip: ip, commands: commands} = Day19.parse_input(input)
    run_commands({0, 0, 0, 0, 0, 0}, ip, commands, {MapSet.new(), nil})
  end

  def run_commands(rs, ip, commands, seen) do
    {cmd, in1, in2, out} = command = Map.fetch!(commands, elem(rs, ip))

    case check_r3_val(command, seen, rs) do
      {:halt, val} ->
        val

      {:cont, vals} ->
        new_val = apply(Day16, cmd, [rs, [in1, in2]])
        rs = put_elem(rs, out, new_val)

        # Increment the IP register and continue
        rs = put_elem(rs, ip, elem(rs, ip) + 1)

        run_commands(rs, ip, commands, vals)
    end
  end

  defp check_r3_val({:eqrr, 3, 0, 4}, {set, last_seen}, registers) do
    r3_val = elem(registers, 3)

    if MapSet.member?(set, r3_val) do
      {:halt, last_seen}
    else
      {:cont, {MapSet.put(set, r3_val), r3_val}}
    end
  end

  defp check_r3_val(_, seen, _), do: {:cont, seen}

  def part1_verify, do: input() |> part1() |> elem(3)
  def part2_verify, do: input() |> part2()
end
