defmodule Mix.Tasks.Bench do
  @moduledoc """
  Run all daily benchmarks for a given year.
  """

  use Mix.Task

  def run([]) do
    Mix.Shell.IO.error("Please provide a year, eg. `mix bench 2015`")
  end

  def run([year]) do
    year
    |> all_benchmarks_for_year()
    |> Benchee.run(Advent.Day.benchee_config())
  end

  defp all_benchmarks_for_year(year) do
    {:ok, modules} = :application.get_key(:advent, :modules)

    modules
    |> Enum.filter(fn module -> only_day_modules(module, year) end)
    |> Enum.flat_map(&benchmarks/1)
    |> Enum.into(%{})
  end

  defp only_day_modules(module_name, year) do
    module_name
    |> Atom.to_string()
    |> String.match?(~r/^Elixir.Y#{year}.Day\d{2}$/)
  end

  defp benchmarks(module_name) do
    apply(module_name, :benchmarks, [])
  end
end
