defmodule Y2023.Day15 do
  use Advent.Day, no: 15

  @doc """
  iex> Day15.part1(~W(rn=1 cm- qp=3 cm=2 qp- pc=4 ot=9 ab=5 pc- pc=6 ot=7))
  1320
  """
  def part1(input) do
    input
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  @doc """
  iex> Day15.part2(~W(rn=1 cm- qp=3 cm=2 qp- pc=4 ot=9 ab=5 pc- pc=6 ot=7))
  145
  """
  def part2(input) do
    input
    |> Enum.reduce(%{}, &place_lens/2)
    |> to_focussing_power()
  end

  defp place_lens(lens, map) do
    {label, op} = parse_lens(lens)
    box_no = hash(label)

    case op do
      "-" ->
        Map.update(map, box_no, [], fn box ->
          Enum.reject(box, fn {x, _} -> x == label end)
        end)

      {"=", focal_length} ->
        entry = {label, focal_length}

        Map.update(map, box_no, [entry], fn list ->
          index = Enum.find_index(list, fn {x, _} -> x == label end)

          if index do
            List.replace_at(list, index, entry)
          else
            list ++ [entry]
          end
        end)
    end
  end

  defp parse_lens(string) do
    if String.contains?(string, "-") do
      label = String.split(string, "-") |> hd()
      {label, "-"}
    else
      [label, num] = String.split(string, "=", parts: 2)
      {label, {"=", String.to_integer(num)}}
    end
  end

  defp to_focussing_power(map) do
    Enum.reduce(map, 0, fn {box_no, lenses}, acc ->
      Enum.reduce(lenses, {1, acc}, fn {_label, length}, {index, acc2} ->
        {index + 1, acc2 + (box_no + 1) * index * length}
      end)
      |> elem(1)
    end)
  end

  @doc """
  iex> Day15.hash("rn=1")
  30

  iex> Day15.hash("cm-")
  253

  iex> Day15.hash("qp=3")
  97
  """
  def hash(string) do
    string
    |> String.to_charlist()
    |> Enum.reduce(0, fn char, acc ->
      rem((acc + char) * 17, 256)
    end)
  end

  @doc """
  iex> Day15.parse_input("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7")
  ~W(rn=1 cm- qp=3 cm=2 qp- pc=4 ot=9 ab=5 pc- pc=6 ot=7)
  """
  def parse_input(input) do
    input
    |> String.split(",", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
