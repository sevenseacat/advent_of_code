defmodule Mix.Tasks.Bench do
  @moduledoc """
  Run all daily benchmarks.
  """

  use Mix.Task

  def run([]) do
    Mix.Shell.IO.error("Please provide a year, eg. `mix bench 2015`")
  end

  def run([year]) do
    {:ok, modules} = :application.get_key(:advent, :modules)

    modules
    |> Enum.map(&"#{&1}")
    |> Enum.filter(fn module -> only_day_modules(module, year) end)
    |> Enum.sort()
    |> Enum.map(&run_bench/1)
  end

  def only_day_modules(module_name, year) do
    String.starts_with?(module_name, "Elixir.Y#{year}.Day")
  end

  def run_bench(module_name) do
    apply(String.to_atom(module_name), :bench, [])
  end
end
