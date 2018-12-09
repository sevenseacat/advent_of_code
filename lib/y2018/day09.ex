defmodule Y2018.Day09 do
  use Advent.Day, no: 9

  @doc """
  iex> Day09.part1("9 players; last marble is worth 25 points")
  32

  iex> Day09.part1("10 players; last marble is worth 1618 points")
  8317

  iex> Day09.part1("13 players; last marble is worth 7999 points")
  146373

  iex> Day09.part1("17 players; last marble is worth 1104 points")
  2764

  iex> Day09.part1("21 players; last marble is worth 6111 points")
  54718

  iex> Day09.part1("30 players; last marble is worth 5807 points")
  37305
  """
  def part1(input) do
    {players, points} = parse_input(input)

    field = :digraph.new()
    :digraph.add_vertex(field, 0)
    :digraph.add_vertex(field, 1)
    :digraph.add_vertex(field, 2)
    :digraph.add_vertex(field, 3)
    :digraph.add_vertex(field, 4)
    :digraph.add_vertex(field, 5)
    :digraph.add_vertex(field, 6)
    :digraph.add_vertex(field, 7)

    :digraph.add_edge(field, 0, 4)
    :digraph.add_edge(field, 4, 2)
    :digraph.add_edge(field, 2, 5)
    :digraph.add_edge(field, 5, 1)
    :digraph.add_edge(field, 1, 6)
    :digraph.add_edge(field, 6, 3)
    :digraph.add_edge(field, 3, 7)
    :digraph.add_edge(field, 7, 0)

    run_game(%{
      scores: %{},
      players: players,
      turn: 7,
      current: 8,
      last: 7,
      max: points,
      field: field
    })
    |> Map.get(:scores)
    |> Enum.max_by(fn {_player, score} -> score end)
    |> elem(1)
  end

  defp run_game(%{current: marble, max: max} = game) when marble > max, do: game

  defp run_game(%{
         players: players,
         turn: turn,
         current: curr,
         last: last,
         field: field,
         scores: scores,
         max: max
       }) do
    {score, new_pos, field} = place_marble(field, curr, last)

    # Progress meter...
    # if rem(curr, div(max, 100)) == 0 do
    #  IO.inspect(curr, label: "#{div(curr, div(max, 100))}%")
    # end

    run_game(%{
      players: players,
      turn: rem(turn + 1, players),
      current: curr + 1,
      last: new_pos,
      field: field,
      scores: Map.update(scores, turn, score, &(&1 + score)),
      max: max
    })
  end

  defp place_marble(graph, new, last) do
    if rem(new, 23) == 0 do
      first = :digraph.in_neighbours(graph, last) |> hd
      second = :digraph.in_neighbours(graph, first) |> hd
      third = :digraph.in_neighbours(graph, second) |> hd
      fourth = :digraph.in_neighbours(graph, third) |> hd
      fifth = :digraph.in_neighbours(graph, fourth) |> hd
      sixth = :digraph.in_neighbours(graph, fifth) |> hd
      seventh = :digraph.in_neighbours(graph, sixth) |> hd
      eighth = :digraph.in_neighbours(graph, seventh) |> hd

      :digraph.del_path(graph, eighth, seventh)
      :digraph.del_path(graph, seventh, sixth)
      :digraph.del_vertex(graph, seventh)
      :digraph.add_edge(graph, eighth, sixth)

      {new + seventh, sixth, graph}
    else
      :digraph.add_vertex(graph, new)
      first = :digraph.out_neighbours(graph, last) |> hd
      second = :digraph.out_neighbours(graph, first) |> hd
      :digraph.del_path(graph, first, second)
      :digraph.add_edge(graph, first, new)
      :digraph.add_edge(graph, new, second)
      {0, new, graph}
    end
  end

  def new_special_position(size, pos) do
    if pos - 7 >= 0, do: pos - 7, else: pos - 7 + size
  end

  defp parse_input(input) do
    ~r/(\d+) players; last marble is worth (\d+) points/
    |> Regex.run(input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1_verify, do: part1("429 players; last marble is worth 70901 points")
  def part2_verify, do: part1("429 players; last marble is worth 7090100 points")
end
