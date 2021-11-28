defmodule Y2015.Day23 do
  use Advent.Day, no: 23

  def part1(cmds) do
    registers = %{"a" => 0, "b" => 0}

    run_commands(cmds, registers, 0, length(cmds))
    |> Map.get("b")
  end

  defp run_commands(_, registers, position, max_position) when position >= max_position do
    registers
  end

  defp run_commands(cmds, registers, position, max) do
    cmd = Enum.at(cmds, position)
    {registers, new_position} = run_command(cmd, registers, position)
    run_commands(cmds, registers, new_position, max)
  end

  def run_command({:hlf, key}, registers, position) do
    registers = Map.update!(registers, key, &div(&1, 2))
    {registers, position + 1}
  end

  def run_command({:tpl, key}, registers, position) do
    registers = Map.update!(registers, key, &(&1 * 3))
    {registers, position + 1}
  end

  def run_command({:inc, key}, registers, position) do
    registers = Map.update!(registers, key, &(&1 + 1))
    {registers, position + 1}
  end

  def run_command({:jmp, offset}, registers, position) do
    {registers, position + offset}
  end

  def run_command({:jie, key, offset}, registers, position) do
    is_even = rem(Map.get(registers, key), 2) == 0
    {registers, if(is_even, do: position + offset, else: position + 1)}
  end

  def run_command({:jio, key, offset}, registers, position) do
    {registers, if(Map.get(registers, key) == 1, do: position + offset, else: position + 1)}
  end

  @doc """
  iex> Day23.parse_input("inc a\\njio a, +2")
  [{:inc, "a"}, {:jio, "a", 2}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(string) do
    string
    |> String.replace(",", "")
    |> String.split(" ")
    |> parse_command()
  end

  defp parse_command(["hlf", reg]), do: {:hlf, reg}
  defp parse_command(["tpl", reg]), do: {:tpl, reg}
  defp parse_command(["inc", reg]), do: {:inc, reg}
  defp parse_command(["jmp", offset]), do: {:jmp, String.to_integer(offset)}
  defp parse_command(["jie", reg, offset]), do: {:jie, reg, String.to_integer(offset)}
  defp parse_command(["jio", reg, offset]), do: {:jio, reg, String.to_integer(offset)}

  def part1_verify, do: input() |> parse_input() |> part1()
end
