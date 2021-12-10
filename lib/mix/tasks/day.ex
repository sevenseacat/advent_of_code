defmodule Mix.Tasks.Day do
  use Mix.Task
  import Mix.Generator, only: [copy_template: 3]

  def run([year, day]) do
    formatted_day = String.pad_leading(day, 2, "0")

    file_path = Path.join([File.cwd!(), "lib", "y#{year}", "day#{formatted_day}.ex"])
    copy_template("priv/templates/day.ex", file_path, year: year, day: formatted_day)

    test_path = Path.join([File.cwd!(), "test", "y#{year}", "day#{formatted_day}_test.exs"])
    copy_template("priv/templates/day_test.ex", test_path, year: year, day: formatted_day)
  end

  def run([]) do
    Mix.Shell.IO.error(
      "Please provide the day number to generate a template for, eg. `mix day 2021 7` for 2021 day 7"
    )
  end
end
