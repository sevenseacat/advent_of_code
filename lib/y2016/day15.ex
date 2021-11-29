defmodule Y2016.Day15 do
  use Advent.Day, no: 15

  @discs [
    %{number: 1, slots: 17, position: 5},
    %{number: 2, slots: 19, position: 8},
    %{number: 3, slots: 7, position: 1},
    %{number: 4, slots: 13, position: 7},
    %{number: 5, slots: 5, position: 1},
    %{number: 6, slots: 3, position: 0}
  ]

  @doc """
  iex> Day15.part1([
  ...>    %{number: 1, slots: 5, position: 4},
  ...>    %{number: 2, slots: 2, position: 1}
  ...> ])
  5
  """
  def part1(discs \\ @discs, slot \\ 0) do
    run_timer(discs, slot, 1)
  end

  def part2(discs \\ @discs, slot \\ 0) do
    run_timer(discs ++ [%{number: 7, slots: 11, position: 0}], slot, 1)
  end

  defp run_timer(discs, slot, time) do
    case drop_capsule(discs, slot, time) do
      :ok ->
        time - 1

      :err ->
        run_timer(tick(discs), slot, time + 1)
    end
  end

  def drop_capsule([], _slot, _time), do: :ok

  def drop_capsule([disc | discs], slot, time) do
    %{position: position} = tick(disc)

    if position == slot do
      drop_capsule(tick(discs), slot, time + 1)
    else
      :err
    end
  end

  def tick(discs) when is_list(discs), do: Enum.map(discs, &tick/1)

  def tick(%{slots: slots, position: position} = disc) do
    %{disc | position: rem(position + 1, slots)}
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
