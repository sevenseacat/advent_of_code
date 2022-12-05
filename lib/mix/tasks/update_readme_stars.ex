defmodule Mix.Tasks.UpdateReadmeStars do
  @moduledoc """
  Write your current stars to your READMEs!

  The main README.md in the repo, plus any files in `lib/y(year)/README.md`, are parsed and updated
  with shiny badges.

  To use:
  * Set up a pre-commit hook for your repo. This is a file in `.git/hooks/pre-commit` that
    calls this mix task (sample content in `pre-commit` in this repo)
  * Add the HTML comment markers to your README files where you want the badges to go.
    eg. `<!-- stars 2022 start --><!-- stars 2022 end -->`
  """
  use Mix.Task
  alias Advent.Stats

  @years 2015..DateTime.utc_now().year

  def run([]) do
    Mix.Shell.IO.info("Updating README stars...")

    star_data =
      Enum.reduce(@years, %{}, fn year, acc ->
        Map.put(acc, year, Stats.count_complete_puzzles(year))
      end)

    Enum.each(readmes(), fn file -> add_stars_to_year_readme(file, star_data) end)
    add_stars_to_main_readme("README.md", star_data)
  end

  defp add_stars_to_main_readme(file, star_data) do
    with {:ok, contents} <- File.read(file) do
      links =
        Enum.map(star_data, fn {year, star_count} ->
          "<a href=\"./lib/y#{year}/\">#{badge_image(year, star_count, :small)}</a>"
        end)
        |> Enum.join("\n")

      contents =
        String.replace(
          contents,
          ~r/#{start_tag()}(.*)#{end_tag()}/s,
          "#{start_tag()}\n#{links}\n#{end_tag()}"
        )

      File.write!(file, contents)
    end
  end

  defp add_stars_to_year_readme(file, star_data) do
    Enum.each(star_data, fn {year, star_count} ->
      add_star_to_year_readme(file, year, star_count)
    end)
  end

  defp add_star_to_year_readme(file, year, star_count) do
    with {:ok, contents} <- File.read(file) do
      new_contents =
        String.replace(
          contents,
          ~r/#{start_tag(year)}(.*)#{end_tag(year)}/,
          "#{start_tag(year)}#{badge_image(year, star_count, :large)}#{end_tag(year)}"
        )

      File.write!(file, new_contents)
    end
  end

  defp start_tag(year), do: "<!-- stars #{year} start -->"
  defp end_tag(year), do: "<!-- stars #{year} end -->"
  defp start_tag(), do: "<!-- stars start -->"
  defp end_tag(), do: "<!-- stars end -->"

  defp badge_image(year, star_count, size) do
    "<img src=\"#{badge_url(year, star_count, size)}\" alt=\"#{star_count} stars\" />"
  end

  defp badge_url(year, star_count, size) do
    style = if size == :small, do: "flat-square", else: "for-the-badge"
    string = if star_count == 50, do: "⭐️_50_stars_⭐️", else: "#{star_count}_stars"

    URI.encode(
      "https://img.shields.io/badge/#{year}-#{string}-#{colour(star_count)}?style=#{style}"
    )
  end

  defp colour(star_count) do
    case star_count do
      50 -> "brightgreen"
      x when x >= 40 -> "green"
      x when x >= 25 -> "yellow"
      x when x >= 10 -> "orange"
      _ -> "red"
    end
  end

  defp readmes() do
    Enum.map(@years, fn year -> "lib/y#{year}/README.md" end)
  end
end
