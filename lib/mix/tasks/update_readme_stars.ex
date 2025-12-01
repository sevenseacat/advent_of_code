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

  @start_year 2015

  def years do
    {:ok, now} = DateTime.now("America/New_York")

    if now.month != 12 do
      @start_year..(now.year - 1)
    else
      @start_year..now.year
    end
  end

  def run([]) do
    Mix.Shell.IO.info("Updating README stars...")

    star_data =
      Enum.reduce(years(), [], fn year, acc ->
        [{year, Stats.count_complete_puzzles(year)} | acc]
      end)

    Enum.each(readmes(), fn file -> add_stars_to_year_readme(file, star_data) end)
    add_stars_to_main_readme("README.md", star_data)
  end

  defp add_stars_to_main_readme(file, star_data) do
    with {:ok, contents} <- File.read(file) do
      links =
        Enum.map(star_data, fn {year, star_count} ->
          "<a href=\"./lib/y#{year}/\">#{badge_image(year, star_count, max_stars(year))}</a>"
        end)
        |> Enum.join("<br />\n")

      # And add a new total at the top

      contents =
        String.replace(
          contents,
          ~r/#{start_tag()}(.*)#{end_tag()}/s,
          "#{start_tag()}\n<p>#{total_badge_image(star_data, years())}</p>\n<p>#{links}</p>#{end_tag()}"
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
          "#{start_tag(year)}#{badge_image(year, star_count, max_stars(year))}#{end_tag(year)}"
        )

      File.write!(file, new_contents)
    end
  end

  defp start_tag(year), do: "<!-- stars #{year} start -->"
  defp end_tag(year), do: "<!-- stars #{year} end -->"
  defp start_tag(), do: "<!-- stars start -->"
  defp end_tag(), do: "<!-- stars end -->"

  defp total_badge_image(star_data, years) do
    max_stars = length(Enum.to_list(years)) * 50
    total_stars = Enum.reduce(star_data, 0, fn {_year, stars}, acc -> stars + acc end)

    badge_image("Total", total_stars, max_stars)
  end

  defp badge_image(year, star_count, max_stars) do
    "<img src=\"#{badge_url(year, star_count, max_stars)}\" alt=\"#{star_count} stars\" />"
  end

  defp badge_url(label, star_count, max_stars) do
    string = if star_count == max_stars, do: "⭐️ #{max_stars} stars ⭐️", else: "#{star_count} stars"

    URI.encode(
      "https://img.shields.io/static/v1?label=#{label}&message=#{string}&style=for-the-badge&color=#{colour(star_count, max_stars)}"
    )
  end

  defp colour(star_count, max_stars) do
    case star_count / max_stars do
      1.0 -> "brightgreen"
      x when x >= 0.8 -> "green"
      x when x >= 0.5 -> "yellow"
      x when x >= 0.2 -> "orange"
      _ -> "red"
    end
  end

  defp readmes() do
    Enum.map(years(), fn year -> "lib/y#{year}/README.md" end)
  end

  defp max_stars(year) when year >= 2025, do: 25
  defp max_stars(_year), do: 50
end
