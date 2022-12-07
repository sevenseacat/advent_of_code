defmodule Y2022.Day07 do
  use Advent.Day, no: 07

  @max_file_size 40_000_000

  def part1(input, max_size \\ 100_000) do
    folder_sizes({"/", input}, [])
    |> Enum.filter(fn {_name, size} -> size <= max_size end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(input) do
    [{"/", root_size} | sizes] = folder_sizes({"/", input}, []) |> Enum.reverse()
    needed = root_size - @max_file_size

    sizes
    |> Enum.filter(fn {_name, size} -> size >= needed end)
    |> Enum.min_by(fn {_name, size} -> size - needed end)
    |> elem(1)
  end

  defp folder_sizes({_name, size}, acc) when is_integer(size), do: acc

  defp folder_sizes({name, children}, acc) do
    Enum.reduce(children, [{name, dirsize(children)} | acc], fn child, acc ->
      folder_sizes(child, acc)
    end)
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

  defp parse_row("$ ls", {data, path}), do: {data, path}
  defp parse_row(<<"$ cd ..">>, {data, path}), do: {data, Enum.drop(path, -1)}
  defp parse_row(<<"$ cd ", name::binary>>, {data, path}), do: {data, path ++ [name]}

  defp parse_row(<<"dir ", name::binary>>, {data, path}) do
    {update_in(data, path, &Map.put(&1, name, %{})), path}
  end

  defp parse_row(file, {data, path}) do
    [size, name] = String.split(file, " ")
    {update_in(data, path, &Map.put(&1, name, String.to_integer(size))), path}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
