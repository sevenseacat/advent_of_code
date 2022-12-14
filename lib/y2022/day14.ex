defmodule Y2022.Day14 do
  use Advent.Day, no: 14

  @sand_source {0, 500}

  def part1(input) do
    # Once the row of a piece of sand has gone past the highest row in the input, it's free-falling
    # and we can stop.
    {highest_row, _lowest_col} = Enum.max(input)
    {{_rock, sand}, _ticks} = tick({input, MapSet.new()}, highest_row, @sand_source, 0)

    MapSet.size(sand)
  end

  defp tick({rock, sand}, highest_row, current_sand, seconds) do
    # display_grid({rock, sand}, current_sand)

    case next_position({rock, sand}, current_sand) do
      ^current_sand ->
        # This sand is now at rest.
        tick({rock, MapSet.put(sand, current_sand)}, highest_row, @sand_source, seconds + 1)

      {row, _col} when row >= highest_row ->
        {{rock, sand}, seconds}

      position ->
        tick({rock, sand}, highest_row, position, seconds + 1)
    end
  end

  defp next_position(state, {row, col}) do
    move(state, {row + 1, col}) || move(state, {row + 1, col - 1}) ||
      move(state, {row + 1, col + 1}) || {row, col}
  end

  defp move({rock, sand}, position) do
    if MapSet.member?(rock, position) || MapSet.member?(sand, position) do
      false
    else
      position
    end
  end

  # @doc """
  # iex> Day14.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(MapSet.new(), &parse_row/2)
  end

  defp parse_row(row, rock_set) do
    row
    |> String.split(" -> ")
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(rock_set, &parse_line/2)
  end

  defp parse_line([from, to], rock_set) do
    [from_col, from_row] = String.split(from, ",", parts: 2) |> Enum.map(&String.to_integer/1)
    [to_col, to_row] = String.split(to, ",", parts: 2) |> Enum.map(&String.to_integer/1)

    for(row <- from_row..to_row, col <- from_col..to_col, do: {row, col})
    |> MapSet.new()
    |> MapSet.union(rock_set)
  end

  def display_grid({rock, sand}, position) do
    {{_, min_col}, {_, max_col}} = Enum.min_max_by(rock, fn {_, col} -> col end)
    {{min_row, _}, {max_row, _}} = Enum.min_max_by(rock, fn {row, _} -> row end)

    Enum.each((min_row - 1)..(max_row + 1), fn row ->
      Enum.reduce((min_col - 1)..(max_col + 1), [], fn col, acc ->
        char =
          cond do
            MapSet.member?(rock, {row, col}) -> "#"
            MapSet.member?(sand, {row, col}) -> "o"
            {row, col} == position -> "x"
            true -> " "
          end

        [char | acc]
      end)
      |> Enum.reverse()
      |> List.to_string()
      |> IO.puts()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
