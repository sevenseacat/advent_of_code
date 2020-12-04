defmodule Y2020.Day04 do
  use Advent.Day, no: 4

  def part1(input) do
    Enum.count(input, &valid_passport?/1)
  end

  @doc """
  iex> Day04.valid_passport?(%{iyr: 2013, ecl: "amb", cid: 350, eyr: 2023, pid: "028048884", hcl: "#cfa07d", byr: 1929})
  false

  iex> Day04.valid_passport?(%{hcl: "#ae17e1", iyr: 2013, eyr: 2024, ecl: "brn", pid: "760753108", byr: 1931, hgt: 179})
  true
  """
  def valid_passport?(data) do
    Enum.all?([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid], fn key -> Map.has_key?(data, key) end)
  end

  @doc """
  iex> Day04.parse_input("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  ...>hcl:#cfa07d byr:1929
  ...>
  ...>hcl:#ae17e1 iyr:2013
  ...>eyr:2024
  ...>ecl:brn pid:760753108 byr:1931
  ...>hgt:179cm
  ...>")
  [
    %{iyr: 2013, ecl: "amb", cid: 350, eyr: 2023, pid: "028048884", hcl: "#cfa07d", byr: 1929},
    %{hcl: "#ae17e1", iyr: 2013, eyr: 2024, ecl: "brn", pid: "760753108", byr: 1931, hgt: "179cm"}
  ]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reduce([], &process_record/2)
    |> Enum.reverse()
  end

  defp process_record([""], acc), do: acc

  defp process_record(record, acc) do
    [Enum.reduce(record, %{}, &process_row/2) | acc]
  end

  defp process_row(row, acc) do
    row
    |> String.split(" ")
    |> Enum.reduce(acc, fn val, acc ->
      [key, val] = String.split(val, ":")
      Map.put(acc, String.to_atom(key), process_val(key, val))
    end)
  end

  defp process_val(num, val) when num in ["iyr", "cid", "eyr", "byr"], do: String.to_integer(val)
  defp process_val(_, val), do: val

  def part1_verify, do: input() |> parse_input() |> part1()
end
