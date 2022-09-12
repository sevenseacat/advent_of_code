defmodule Y2018.Day19 do
  use Advent.Day, no: 19

  def part1(input) do
    %{ip: ip, commands: commands} = parse_input(input)
    run_commands({0, 0, 0, 0, 0, 0}, ip, commands)
  end

  def part2(_input) do
    # %{ip: ip, commands: commands} = parse_input(input)
    # run_commands({1, 0, 0, 0, 0, 0}, ip, commands)
    # lol no it's not that simple.

    # imma reverse engineer the fuck outta this. this is very reminiscent of day 23 from last year.
    # part 1 - first loop is when registers are {0, 4, 1, 1, 1, 950}
    # part 2 - first loop is when registers are {0, 4, 1, 1, 1, 10551350}
    # so part 2's outermost loop is stupidly longer than part 1

    # what does the loop in part 1 actually do? if I know that, I can repeat process for part 2.
    # loops over commands 3-11, adding (reg 2 value) to reg 5 every time cmd 4 is hit.
    # when reg 5 == reg 6, reg 1 and reg 3 are incremented.
    # loop starts again.
    # reg 4 is getting set to reg 5 * reg 3 every time cmd 4 is triggered, before immediately
    # going back to 0. I'm sure this will be relevant at some point.
    # when reg 6 (950) / reg 5 (475) = reg 2 (2) on cmd 8, reg 1 is increased by 2 (reg 3?) to 3.
    # will the same loop hold again?
    # no. dammit.
    # (yes, this is going to be a stream of thought solution.)
    # when reg 1 is 3, the loop goes all the way to 950 again. because reg 2 is odd?
    # when reg 5 gets to 950, reg 3 increments to 5.
    # we're doing divisors of 950, aren't we? this loop should stop on 950/5 = 190.
    # it didn't stop, but when it got to 190, reg 1 incremented by 5 (reg 2)! now we're onto something.
    # next divisor of 950 is 10. if my prediction is right, all the looping should continue up to
    # 950, then when reg 3 is 10, and reg 5 is 95, reg 1 should become 18.
    # {8, 7, 10, 1, 95, 950}
    # {18, 8, 10, 1, 95, 950}
    # I love when I'm right.
    # so we're just adding up all the divisors of the number in reg 6, in a crazy long complicated way.
    # I googled. And found this: http://www.javascripter.net/math/calculators/divisorscalculator.htm
    # for 950, the answer is indeed 1860, like in part 1.
    # for 10551350, it says the answer is 20108088. is it?
    # > That's the right answer! You are one gold star closer to fixing the time stream.
    # a winner is me.
    # this function deliberately left blank
  end

  def run_commands(rs, ip, commands) do
    command = Map.get(commands, elem(rs, ip))

    case command do
      nil ->
        # Not a valid command - decrement the IP register and exit.
        put_elem(rs, ip, elem(rs, ip) - 1)

      {cmd, in1, in2, out} ->
        # Run the command and update the out register
        rs = put_elem(rs, out, apply(Y2018.Day16, cmd, [rs, [in1, in2]]))

        # Increment the IP register and continue
        rs = put_elem(rs, ip, elem(rs, ip) + 1)
        run_commands(rs, ip, commands)
    end
  end

  def parse_input(input) do
    [ip | commands] =
      input
      |> String.split("\n", trim: true)

    %{
      ip: ip |> String.replace("#ip ", "") |> String.to_integer(),
      commands: Enum.reduce(commands, {%{}, 0}, &parse_command/2) |> elem(0)
    }
  end

  defp parse_command(cmd, {map, count}) do
    [a, b, c, d] = String.split(cmd, " ")
    cmd = {String.to_atom(a), String.to_integer(b), String.to_integer(c), String.to_integer(d)}
    {Map.put(map, count, cmd), count + 1}
  end

  def part1_verify, do: input() |> part1() |> elem(0)
end
