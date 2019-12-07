defmodule Y2019.Day07 do
  use Advent.Day, no: 7

  def part1(input) do
    input
    |> parse_input()
    |> calculate_outputs(phase_setting_permutations(Enum.to_list(0..4)))
    |> Enum.max_by(fn {_phases, output} -> output end)
    |> elem(1)
  end

  def calculate_outputs(array, phase_settings) do
    Enum.map(phase_settings, fn setting -> {setting, calculate_output(array, setting)} end)
  end

  @doc """
  iex> Day07.calculate_output(:array.from_list([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]), [4,3,2,1,0])
  43210

  iex> Day07.calculate_output(:array.from_list([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]), [0,1,2,3,4])
  54321

  iex> Day07.calculate_output(:array.from_list([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]), [1,0,4,3,2])
  65210
  """
  def calculate_output(array, phase_settings) do
    Enum.reduce(phase_settings, 0, fn setting, output ->
      Y2019.Day05.run_program(array, [setting, output]) |> elem(1) |> hd
    end)
  end

  # https://rosettacode.org/wiki/Permutations#Elixir
  defp phase_setting_permutations([]), do: [[]]

  defp phase_setting_permutations(list) do
    for x <- list, y <- phase_setting_permutations(list -- [x]), do: [x | y]
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  def part1_verify, do: input() |> part1()
end
