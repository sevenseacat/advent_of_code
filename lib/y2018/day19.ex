defmodule Y2018.Day19 do
  use Advent.Day, no: 19

  def part1(input) do
    %{ip: ip, commands: commands} = parse_input(input)

    map =
      commands
      |> Enum.reduce({%{}, 0}, fn cmd, {map, count} ->
        {Map.put(map, count, cmd), count + 1}
      end)
      |> elem(0)

    run_commands([0, 0, 0, 0, 0, 0], ip, map)
  end

  defp run_commands(rs, ip, commands) do
    command = Map.get(commands, Enum.at(rs, ip))

    case command do
      nil ->
        # Not a valid command - decrement the IP register and exit.
        List.replace_at(rs, ip, Enum.at(rs, ip) - 1)

      {cmd, in1, in2, out} ->
        # Run the command and update the out register
        rs = List.replace_at(rs, out, apply(Y2018.Day16, cmd, [rs, [in1, in2]]))

        # Increment the IP register and continue
        rs = List.replace_at(rs, ip, Enum.at(rs, ip) + 1)
        run_commands(rs, ip, commands)
    end
  end

  def parse_input(input) do
    [ip | commands] =
      input
      |> String.split("\n", trim: true)

    %{
      ip: ip |> String.replace("#ip ", "") |> String.to_integer(),
      commands: Enum.map(commands, &parse_command/1)
    }
  end

  defp parse_command(cmd) do
    [a, b, c, d] = String.split(cmd, " ")
    {String.to_atom(a), String.to_integer(b), String.to_integer(c), String.to_integer(d)}
  end

  def part1_verify, do: input() |> part1() |> Enum.at(0)
end
