defmodule Y2019.Day07 do
  use Advent.Day, no: 7

  alias Y2019.Day07.Amplifier

  def part1(input), do: do_parts(input, 0..4)

  def part2(input), do: do_parts(input, 5..9)

  defp do_parts(input, phase_setting_range) do
    input
    |> parse_input()
    |> calculate_outputs(phase_setting_permutations(Enum.to_list(phase_setting_range)))
    |> Enum.max_by(fn {_phases, output} -> output end)
    |> elem(1)
  end

  defp calculate_outputs(array, phase_settings) do
    Enum.map(phase_settings, fn setting -> {setting, calculate_output(array, setting)} end)
  end

  @doc """
  iex> Day07.calculate_output(:array.from_list([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]), [4,3,2,1,0])
  43210

  iex> Day07.calculate_output(:array.from_list([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]), [0,1,2,3,4])
  54321

  iex> Day07.calculate_output(:array.from_list([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]), [1,0,4,3,2])
  65210

  iex> Day07.calculate_output(:array.from_list([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
  ...> 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]), [9,8,7,6,5])
  139629729

  iex> Day07.calculate_output(:array.from_list([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,
  ...> 55,26,1001,54, -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
  ...> 53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]), [9,7,8,5,6])
  18216
  """
  def calculate_output(array, phase_settings) do
    to = %{"A" => "B", "B" => "C", "C" => "D", "D" => "E", "E" => "A"}

    ["A", "B", "C", "D", "E"]
    |> Enum.zip(phase_settings)
    |> Enum.each(fn {id, setting} ->
      {:ok, _amplifier} = Amplifier.start_link(id, Map.get(to, id), setting, array)
    end)

    Amplifier.send_input("A", 0)

    :timer.sleep(5000)
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
