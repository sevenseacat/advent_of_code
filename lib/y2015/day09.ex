defmodule Y2015.Day09 do
  use Advent.Day, no: 9

  @doc """
  iex> Day09.part1("London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141")
  {["London", "Dublin", "Belfast"], 605}
  """
  def part1(input) do
    input = parse_input(input)
    locations = all_locations(input)

    locations
    |> Enum.map(fn loc -> all_routes_from(loc, [], 0, input, length(locations)) end)
    |> List.flatten()
    |> Enum.filter(fn {locs, _} -> length(locs) == length(locations) end)
    |> Enum.min_by(fn {_route, length} -> length end)
  end

  @doc """
  iex> Day09.part2("London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141")
  {["Dublin", "London", "Belfast"], 982}
  """
  def part2(input) do
    input = parse_input(input)
    locations = all_locations(input)

    locations
    |> Enum.map(fn loc -> all_routes_from(loc, [], 0, input, length(locations)) end)
    |> List.flatten()
    |> Enum.filter(fn {locs, _} -> length(locs) == length(locations) end)
    |> Enum.max_by(fn {_route, length} -> length end)
  end

  defp all_locations(edges) do
    edges
    |> Enum.map(fn {x, y, _z} -> [x, y] end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp all_routes_from(start_point, seen, distance, edges, limit) do
    seen = [start_point | seen]

    if length(seen) == limit do
      {Enum.reverse(seen), distance}
    else
      start_point
      |> find_destinations_from(edges)
      |> Enum.filter(fn {dest, _} -> !Enum.member?(seen, dest) end)
      |> Enum.map(fn {move, dist} ->
        all_routes_from(move, seen, distance + dist, edges, limit)
      end)
    end
  end

  defp find_destinations_from(loc, edges) do
    edges
    |> Enum.filter(fn {x, y, _} -> x == loc || y == loc end)
    |> Enum.map(fn {x, y, dist} -> {if(x == loc, do: y, else: x), dist} end)
  end

  @doc """
  iex> Day09.parse_input("London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141")
  [{"London", "Dublin", 464}, {"London", "Belfast", 518}, {"Dublin", "Belfast", 141}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(input) do
    [from, to, dist] = String.split(input, [" to ", " = "])
    {from, to, String.to_integer(dist)}
  end

  def part1_verify, do: input() |> part1() |> elem(1)
  def part2_verify, do: input() |> part2() |> elem(1)
end
