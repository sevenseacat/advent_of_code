defmodule Y2020.Day04 do
  use Advent.Day, no: 4

  def part1(input) do
    Enum.count(input, &valid_fields?/1)
  end

  @doc """
  iex> Day04.valid_fields?(%{iyr: 2013, ecl: "amb", cid: 350, eyr: 2023, pid: "028048884", hcl: "#cfa07d", byr: 1929})
  false

  iex> Day04.valid_fields?(%{hcl: "#ae17e1", iyr: 2013, eyr: 2024, ecl: "brn", pid: "760753108", byr: 1931, hgt: 179})
  true
  """
  def valid_fields?(data) do
    Enum.all?([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid], fn key -> Map.has_key?(data, key) end)
  end

  def part2(input) do
    Enum.count(input, fn p -> valid_fields?(p) && valid_values?(p) end)
  end

  @doc """
  iex> Day04.valid_values?(%{byr: 2002})
  true

  iex> Day04.valid_values?(%{byr: 2003})
  false

  iex> Day04.valid_values?(%{hgt: "60in"})
  true

  iex> Day04.valid_values?(%{hgt: "190cm"})
  true

  iex> Day04.valid_values?(%{hgt: "190in"})
  false

  iex> Day04.valid_values?(%{hgt: "190"})
  false

  iex> Day04.valid_values?(%{hcl: "#123abc"})
  true

  iex> Day04.valid_values?(%{hcl: "#123abz"})
  false

  iex> Day04.valid_values?(%{hcl: "123abc"})
  false

  iex> Day04.valid_values?(%{ecl: "brn"})
  true

  iex> Day04.valid_values?(%{ecl: "wat"})
  false

  iex> Day04.valid_values?(%{pid: "000000001"})
  true

  iex> Day04.valid_values?(%{pid: "0123456789"})
  false
  """
  def valid_values?(data) do
    Enum.all?(data, fn {key, val} -> valid_value?(key, val) end)
  end

  defp valid_value?(:byr, val), do: val >= 1920 && val <= 2002
  defp valid_value?(:iyr, val), do: val >= 2010 && val <= 2020
  defp valid_value?(:eyr, val), do: val >= 2020 && val <= 2030

  defp valid_value?(:hgt, val) do
    cond do
      String.contains?(val, "in") ->
        val = val |> String.replace("in", "") |> String.to_integer()
        val >= 59 && val <= 76

      String.contains?(val, "cm") ->
        val = val |> String.replace("cm", "") |> String.to_integer()
        val >= 150 && val <= 193

      true ->
        false
    end
  end

  defp valid_value?(:hcl, val), do: Regex.match?(~r/^#[0-9a-f]{6}$/, val)
  defp valid_value?(:ecl, val), do: val in ~W/amb blu brn gry grn hzl oth/
  defp valid_value?(:pid, val), do: String.length(val) == 9
  defp valid_value?(_, _), do: true

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
  def part2_verify, do: input() |> parse_input() |> part2()
end
