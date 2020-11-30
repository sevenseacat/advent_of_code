defmodule Y2015.Day19 do
  use Advent.Day, no: 19

  @medicine "CRnCaSiRnBSiRnFArTiBPTiTiBFArPBCaSiThSiRnTiBPBPMgArCaSiRnTiMgArCaSiThCaSiRnFArRnSiRnFArTiTiBFArCaCaSiRnSiThCaCaSiRnMgArFYSiRnFYCaFArSiThCaSiThPBPTiMgArCaPRnSiAlArPBCaCaSiRnFYSiThCaRnFArArCaCaSiRnPBSiRnFArMgYCaCaCaCaSiThCaCaSiAlArCaCaSiRnPBSiAlArBCaCaCaCaSiThCaPBSiThPBPBCaSiRnFYFArSiThCaSiRnFArBCaCaSiRnFYFArSiThCaPBSiThCaSiRnPMgArRnFArPTiBCaPRnFArCaCaCaCaSiRnCaCaSiRnFYFArFArBCaSiThFArThSiThSiRnTiRnPMgArFArCaSiThCaPBCaSiRnBFArCaCaPRnCaCaPMgArSiRnFYFArCaSiThRnPBPMgAr"

  @doc """
  iex> Day19.part1([{"H", "HO"}, {"H", "OH"}, {"O", "HH"}], "HOH")
  ["HHHH", "HOHO", "HOOH", "OHOH"]

  iex> Day19.part1([{"H", "HO"}, {"H", "OH"}, {"O", "HH"}], "HOHOHO") |> length
  7
  """
  def part1(rules, medicine \\ @medicine) do
    rules
    |> Enum.map(fn rule -> find_replacements(medicine, rule) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
    |> Kernel.--([medicine])
  end

  defp find_replacements(medicine, {from, to}) do
    match_count = String.split(medicine, from) |> length

    0..match_count
    |> Enum.map(fn i -> replace_nth(medicine, from, to, i) end)
  end

  defp replace_nth(input, from, to, n) do
    String.replace(input, ~r/((?:.*?#{from}.*?){#{n - 1}}.*?)#{from}/, "\\1#{to}", global: false)
  end

  @doc """
  iex> Day19.parse_input("Al => ThF\\nAl => ThRnFAr")
  [{"Al", "ThF"}, {"Al", "ThRnFAr"}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row -> String.split(row, " => ", parts: 2) |> List.to_tuple() end)
    |> Enum.into([])
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> length()
end
