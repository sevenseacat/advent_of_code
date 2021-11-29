defmodule Advent.Day do
  defmacro __using__(no: day_no) when is_integer(day_no) do
    formatted_day_no = if day_no < 10, do: "0#{day_no}", else: "#{day_no}"

    quote do
      @doc """
      Read an input data file with the specified file name.
      This should be located in a `data` folder alongside the module.
      """
      def data(filename \\ "day#{unquote(formatted_day_no)}") do
        data_folder = __ENV__.file |> Path.dirname()

        "#{data_folder}/data/#{filename}.txt"
        |> File.read!()
        |> String.trim()
      end

      def bench do
        Benchee.run(benchmarks(), benchee_config())

        :ok
      end

      def benchmarks do
        %{
          "day #{unquote(formatted_day_no)}, part 1" => &part1_verify/0,
          "day #{unquote(formatted_day_no)}, part 2" => &part2_verify/0
        }
      end

      defdelegate benchee_config(), to: unquote(__MODULE__)
    end
  end

  def benchee_config do
    [
      print: [benchmarking: false],
      formatters: [{Benchee.Formatters.Console, comparison: false}]
    ]
  end
end
