defmodule Y2021.Day20 do
  use Advent.Day, no: 20

  use Bitwise

  def parts({algorithm, image}, times \\ 2) do
    run_transformations({algorithm, image}, times)
    |> Enum.count(fn {_coord, val} -> val == "#" end)
  end

  def display_image(image) do
    {{{min, _}, _val1}, {{_, max}, _val2}} =
      Enum.min_max_by(image, fn {{x, y}, _val} -> {x, y} end)

    for(
      row <- min..max,
      col <- min..max,
      do: Map.get(image, {row, col}, ".")
    )
    |> List.flatten()
    |> Enum.chunk_every(max - min + 1)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&IO.inspect/1)

    image
  end

  defp run_transformations({_algorithm, image}, 0), do: image

  defp run_transformations(input, num) do
    input
    |> transform_image(num)
    |> run_transformations(num - 1)
  end

  defp transform_image({algorithm, image}, num) do
    {{{min_row, min_col}, _val1}, {{max_row, max_col}, _val2}} =
      Enum.min_max_by(image, fn {{x, y}, _val} -> {x, y} end)

    new_image =
      for row <- (min_row - 1)..(max_row + 1), col <- (min_col - 1)..(max_col + 1) do
        {{row, col}, get_pixel_value({row, col}, {algorithm, image}, num)}
      end
      |> Enum.into(%{})

    {algorithm, new_image}
  end

  def get_pixel_value({row, col}, {algorithm, image}, num) do
    algo_offset =
      [
        {row - 1, col - 1},
        {row - 1, col},
        {row - 1, col + 1},
        {row, col - 1},
        {row, col},
        {row, col + 1},
        {row + 1, col - 1},
        {row + 1, col},
        {row + 1, col + 1}
      ]
      |> Enum.reduce(0, fn coord, acc ->
        (acc <<< 1) + (Map.get(image, coord, default(algorithm, num)) |> to_binary_value())
      end)

    Enum.at(algorithm, algo_offset)
  end

  defp to_binary_value("#"), do: 1
  defp to_binary_value("."), do: 0

  # An infinite grid will toggle between on/off if the default value of the algorithm (position 0) is on.
  defp default(["." | _rest], _num), do: "."

  defp default(["#" | _rest], num) do
    if rem(num, 2) == 0, do: ".", else: "#"
  end

  @doc """
  iex> Day20.parse_input("..##.#.\\n\\n.#\\n#.\\n")
  {[".", ".", "#", "#", ".", "#", "."], %{{0,0} => ".", {0,1} => "#", {1,0} => "#", {1,1} => "."}}
  """

  def parse_input(input) do
    [algorithm, image] = String.split(input, "\n\n", trim: true)
    {String.graphemes(algorithm), parse_image(image)}
  end

  def parse_image(input) do
    rows = String.split(input, "\n", trim: true)

    for(
      {row, row_index} <- Enum.with_index(rows),
      {col, col_index} <- Enum.with_index(String.graphemes(row)),
      do: {{row_index, col_index}, col}
    )
    |> Enum.into(%{})
  end

  def part1_verify, do: input() |> parse_input() |> parts()
  def part2_verify, do: input() |> parse_input() |> parts(50)
end
