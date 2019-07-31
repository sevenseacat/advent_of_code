defmodule Advent.Day do
  defmacro __using__(no: day_no) when is_integer(day_no) do
    formatted_day_no = if day_no < 10, do: "0#{day_no}", else: "#{day_no}"

    quote do
      @doc """
      Read an input file with the specified file name.
      This should be located in a `input` folder alongside the module.
      """
      def input(filename \\ "day#{unquote(formatted_day_no)}") do
        input_folder = __ENV__.file |> Path.dirname()

        "#{input_folder}/input/#{filename}.txt"
        |> File.read!()
        |> String.trim_trailing()
      end

      def bench do
        Benchee.run(benchmarks(), benchee_config())

        :ok
      end

      def benchmarks do
        %{
          "day #{unquote(formatted_day_no)}, part 1" => maybe_run(:part1_verify),
          "day #{unquote(formatted_day_no)}, part 2" => maybe_run(:part2_verify)
        }
        |> Enum.filter(fn {name, fun} -> fun end)
        |> Enum.into(%{})
      end

      # Only run a benchmark if it is defined.
      # It will only be defined if the puzzle has been solved!
      def maybe_run(func_name) do
        if Kernel.function_exported?(__MODULE__, func_name, 0) do
          fn -> Kernel.apply(__MODULE__, func_name, []) end
        end
      end

      defdelegate benchee_config(), to: unquote(__MODULE__)
    end
  end

  def benchee_config do
    [
      print: [benchmarking: true, configuration: false],
      formatters: [{Benchee.Formatters.Console, comparison: false}],
      unit_scaling: :smallest
    ]
  end
end
