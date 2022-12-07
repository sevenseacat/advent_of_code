defmodule Y2022.Day07 do
  use Advent.Day, no: 07

  def part1(input, max_size \\ 100_000) do
    do_part1({"/", input}, max_size, [])
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp do_part1({_name, size}, _max_size, acc) when is_integer(size), do: acc

  defp do_part1({name, children}, max_size, acc) do
    acc = maybe_add({name, children}, max_size, acc)

    Enum.reduce(children, acc, fn child, acc ->
      do_part1(child, max_size, acc)
    end)
  end

  defp maybe_add({name, children}, max_size, acc) do
    dirsize = dirsize(children)

    if dirsize <= max_size do
      [{name, dirsize} | acc]
    else
      acc
    end
  end

  defp dirsize(int) when is_integer(int), do: int

  defp dirsize(directory) do
    Enum.map(
      directory,
      fn
        {_key, size} when is_integer(size) -> size
        {_key, children} when is_map(children) -> dirsize(children)
      end
    )
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.reduce({%{"/" => %{}}, ["/"]}, &parse_row/2)
    |> elem(0)
    |> Map.get("/")
  end

  defp parse_row("$ ls", {data, index}), do: {data, index}

  defp parse_row(<<"dir ", name::binary>>, {data, index}) do
    {update_in(data, index, fn folder -> Map.put(folder, name, %{}) end), index}
  end

  defp parse_row(<<"$ cd ..">>, {data, index}) do
    {data, Enum.drop(index, -1)}
  end

  defp parse_row(<<"$ cd ", name::binary>>, {data, index}) do
    {data, index ++ [name]}
  end

  defp parse_row(file, {data, index}) do
    [size, name] = String.split(file, " ")

    {update_in(data, index, fn folder -> Map.put(folder, name, String.to_integer(size)) end),
     index}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
