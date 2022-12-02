defmodule Y2022.Day02 do
  use Advent.Day, no: 02

  @rock "X"
  @paper "Y"
  @scissors "Z"

  @lose "X"
  @draw "Y"
  @win "Z"

  @doc """
  iex> Day02.part1([{:rock, "Y"}, {:paper, "X"}, {:scissors, "Z"}])
  15
  """
  def part1(input), do: do_parts(input, &part1_game/1)

  @doc """
  iex> Day02.part2([{:rock, "Y"}, {:paper, "X"}, {:scissors, "Z"}])
  12
  """
  def part2(input), do: do_parts(input, &part2_game/1)

  def do_parts(input, winner_fn) do
    input
    |> Enum.map(fn game -> game(game, winner_fn).score end)
    |> Enum.sum()
  end

  @doc """
  iex> Day02.game({:rock, "Y"})
  %{winner: :you, score: 8}

  iex> Day02.game({:paper, "X"})
  %{winner: :them, score: 1}

  iex> Day02.game({:scissors, "Z"})
  %{winner: nil, score: 6}
  """
  def game({one, two}, winner_fn \\ &part1_game/1) do
    %{winner: winner, you: you} = winner_fn.({one, two})
    %{winner: winner, score: winner_score(winner) + your_score(you)}
  end

  defp part1_game({them, you}) do
    winner =
      case {them, you} do
        {:rock, @scissors} -> :them
        {:rock, @paper} -> :you
        {:scissors, @rock} -> :you
        {:scissors, @paper} -> :them
        {:paper, @scissors} -> :you
        {:paper, @rock} -> :them
        _ -> nil
      end

    %{winner: winner, you: you}
  end

  defp part2_game({them, result}) do
    you =
      case {them, result} do
        {:rock, @win} -> @paper
        {:rock, @lose} -> @scissors
        {:rock, @draw} -> @rock
        {:scissors, @win} -> @rock
        {:scissors, @lose} -> @paper
        {:scissors, @draw} -> @scissors
        {:paper, @win} -> @scissors
        {:paper, @lose} -> @rock
        {:paper, @draw} -> @paper
      end

    winner =
      case result do
        @win -> :you
        @lose -> :them
        @draw -> nil
      end

    %{winner: winner, you: you}
  end

  defp winner_score(:you), do: 6
  defp winner_score(:them), do: 0
  defp winner_score(nil), do: 3

  defp your_score(@rock), do: 1
  defp your_score(@paper), do: 2
  defp your_score(@scissors), do: 3

  @doc """
  iex> Day02.parse_input("A Y\\nB X\\nC Z")
  [{:rock, "Y"}, {:paper, "X"}, {:scissors, "Z"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn <<one::binary-1, " ", two::binary-1>> -> {to_shape(one), two} end)
  end

  defp to_shape("A"), do: :rock
  defp to_shape("B"), do: :paper
  defp to_shape("C"), do: :scissors

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
