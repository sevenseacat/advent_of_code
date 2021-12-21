defmodule Y2016.Day14 do
  use Advent.Day, no: 14

  alias Y2016.Day14.Cache

  @salt "zpqevtbw"
  @max_keys 64

  def part1(salt \\ @salt, max_keys \\ @max_keys) do
    look_for_key(0, 0, max_keys, Cache.start(&hash/2, salt))
  end

  def part2(salt \\ @salt, max_keys \\ @max_keys) do
    look_for_key(0, 0, max_keys, Cache.start(&super_hash/2, salt))
  end

  def look_for_key(index, max_keys, max_keys, _cache), do: index - 1

  def look_for_key(index, key_count, max_keys, cache) do
    if key?(index, cache) do
      # IO.puts("Found key #{map_size(keys) + 1}: #{index}")
      look_for_key(index + 1, key_count + 1, max_keys, cache)
    else
      look_for_key(index + 1, key_count, max_keys, cache)
    end
  end

  @doc """
  iex> Day14.key?(18, Cache.start(&Day14.hash/2, "abc"))
  false # has triple but is not key

  iex> Day14.key?(38, Cache.start(&Day14.hash/2, "abc"))
  false

  iex> Day14.key?(39, Cache.start(&Day14.hash/2, "abc"))
  true

  iex> Day14.key?(40, Cache.start(&Day14.hash/2, "abc"))
  false

  iex> Day14.key?(5, Cache.start(&Day14.super_hash/2, "abc"))
  false # triple but not key

  iex> Day14.key?(10, Cache.start(&Day14.super_hash/2, "abc"))
  true

  iex> Day14.key?(11, Cache.start(&Day14.super_hash/2, "abc"))
  false

  iex> Day14.key?(22551, Cache.start(&Day14.super_hash/2, "abc"))
  true
  """
  def key?(index, cache) do
    {is_triple, letter} = Cache.hash(cache, index) |> is_triple?

    is_triple && check_for_five_char_sequence(index, letter, cache)
  end

  def is_triple?(string) do
    case Regex.run(~r/([a-z0-9])\1\1/, string) do
      nil -> {false, nil}
      [_triple, single] -> {true, single}
    end
  end

  def check_for_five_char_sequence(index, letter, cache) do
    sequence = String.duplicate(letter, 5)

    Enum.any?((index + 1)..(index + 1000), fn new_index ->
      Cache.hash(cache, new_index) |> String.contains?(sequence)
    end)
  end

  @doc """
  iex> Day14.hash("abc18") |> String.contains?("cc38887a5")
  true
  """
  def hash(index, salt), do: hash("#{salt}#{index}")
  def hash(string), do: :erlang.md5(string) |> Base.encode16(case: :lower)

  @doc """
  iex> Day14.super_hash(0, "abc")
  "a107ff634856bb300138cac6568c0f24"
  """
  def super_hash(index, salt) do
    Enum.reduce(1..2017, "#{salt}#{index}", fn _x, acc -> hash(acc) end)
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
