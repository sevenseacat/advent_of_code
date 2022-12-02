defmodule Y2022.Day02 do
  use Advent.Day, no: 02

  @rock "X"
  @paper "Y"
  @scissors "Z"

  @doc """
  iex> Day02.part1([{:rock, "Y"}, {:paper, "X"}, {:scissors, "Z"}])
  15
  """
  def part1(input) do
    input
    |> Enum.map(fn game -> game(game).score end)
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
  def game({one, two}) do
    winner = winner({one, two})
    %{winner: winner, score: winner_score(winner) + your_score(two)}
  end

  defp winner(shapes) do
    case shapes do
      {:rock, @scissors} -> :them
      {:rock, @paper} -> :you
      {:scissors, @rock} -> :you
      {:scissors, @paper} -> :them
      {:paper, @scissors} -> :you
      {:paper, @rock} -> :them
      _ -> nil
    end
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
end
