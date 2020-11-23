defmodule Y2015.Day13 do
  use Advent.Day, no: 13

  def part1(input) do
    input = parse_input(input)
    sorted_best_table(input, list_people(input))
  end

  def part2(input) do
    input = parse_input(input)
    sorted_best_table(input, ["you" | list_people(input)])
  end

  def sorted_best_table(data, people) do
    people
    |> Advent.permutations(length(people))
    |> Enum.map(fn order -> calculate_result(order, data) end)
    |> Enum.max_by(fn {_order, result} -> result end)
  end

  defp list_people(data) do
    data
    |> Enum.map(fn {from, _to, _val} -> from end)
    |> Enum.uniq()
  end

  defp calculate_result(order, data) do
    order
    |> Enum.with_index()
    |> Enum.map(fn {name, index} -> find_left_and_right(name, index, order) end)
    |> Enum.map(fn row -> get_score_for_person(row, data) end)
    |> with_total_score
  end

  defp find_left_and_right(name, index, order) do
    left_index = if index == 0, do: length(order) - 1, else: index - 1
    right_index = if index == length(order) - 1, do: 0, else: index + 1

    [name, Enum.at(order, left_index), Enum.at(order, right_index)]
  end

  defp get_score_for_person([person, left, right], data) do
    {person, get_score(person, left, data) + get_score(person, right, data)}
  end

  defp with_total_score(data) do
    total_score =
      data
      |> Enum.map(fn person -> elem(person, 1) end)
      |> Enum.sum()

    {data, total_score}
  end

  defp get_score(person, next_to, data) do
    case Enum.find(data, fn {from, to, _score} -> from == person && to == next_to end) do
      # must be "you" and no-one cares about sitting next to you
      nil -> 0
      {_from, _to, score} -> score
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  def parse_row(input) do
    [[_string, from, neg, value, to]] =
      Regex.scan(
        ~r/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\./,
        input
      )

    value = String.to_integer(value)
    value = if neg == "lose", do: -value, else: value
    {from, to, value}
  end

  def part1_verify, do: input() |> part1() |> elem(1)
  def part2_verify, do: input() |> part2() |> elem(1)
end
