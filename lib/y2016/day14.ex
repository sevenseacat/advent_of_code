defmodule Y2016.Day14 do
  use Advent.Day, no: 14

  alias Y2016.Day14.Cache

  @salt "zpqevtbw"
  @max_keys 64

  def part1(salt \\ @salt, max_keys \\ @max_keys) do
    look_for_key(0, %{}, salt, max_keys, &hash/2, Cache.start())
  end

  def part2(salt \\ @salt, max_keys \\ @max_keys) do
    look_for_key(0, %{}, salt, max_keys, &super_hash/2, Cache.start())
  end

  def look_for_key(index, keys, _salt, max_keys, _hash_fn, _cache)
      when map_size(keys) == max_keys,
      do: index - 1

  def look_for_key(index, keys, salt, max_keys, hash_fn, cache) do
    if key?(index, salt, hash_fn, cache) do
      # IO.puts("Found key #{map_size(keys) + 1}: #{index}")
      look_for_key(index + 1, Map.put_new(keys, index, true), salt, max_keys, hash_fn, cache)
    else
      look_for_key(index + 1, keys, salt, max_keys, hash_fn, cache)
    end
  end

  @doc """
  iex> Day14.key?(18, "abc", &Day14.hash/2, Cache.start())
  false # has triple but is not key

  iex> Day14.key?(38, "abc", &Day14.hash/2, Cache.start())
  false

  iex> Day14.key?(39, "abc", &Day14.hash/2, Cache.start())
  true

  iex> Day14.key?(40, "abc", &Day14.hash/2, Cache.start())
  false

  iex> Day14.key?(5, "abc", &Day14.super_hash/2, Cache.start())
  false # triple but not key

  iex> Day14.key?(10, "abc", &Day14.super_hash/2, Cache.start())
  true

  iex> Day14.key?(11, "abc", &Day14.super_hash/2, Cache.start())
  false

  iex> Day14.key?(22551, "abc", &Day14.super_hash/2, Cache.start())
  true
  """
  def key?(index, salt, hash_fn, cache) do
    {is_triple, letter} = Cache.hash(cache, index, salt, hash_fn) |> is_triple?

    is_triple && check_for_five_char_sequence(index, salt, letter, hash_fn, cache)
  end

  def is_triple?(string) do
    case Regex.run(~r/([a-z0-9])\1\1/, string) do
      nil -> {false, nil}
      [_triple, single] -> {true, single}
    end
  end

  def check_for_five_char_sequence(index, salt, letter, hash_fn, cache) do
    Enum.any?((index + 1)..(index + 1000), fn new_index ->
      Cache.hash(cache, new_index, salt, hash_fn) |> has_five_char_sequence?(letter)
    end)
  end

  @doc """
  iex> Day14.has_five_char_sequence?("abc123", "a")
  false

  iex> Day14.has_five_char_sequence?("abcaaaaa123", "a")
  true
  """
  def has_five_char_sequence?(string, letter) do
    String.contains?(string, String.duplicate(letter, 5))
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
  def super_hash(index, salt), do: "#{salt}#{index}" |> do_super_hash(0)
  def do_super_hash(string, 2017), do: string
  def do_super_hash(string, index), do: string |> hash |> do_super_hash(index + 1)

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
