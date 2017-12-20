defmodule Y2017.Day15.Generator do
  def new(initial, factor) do
    Stream.unfold(initial, &{&1, next_val(&1, factor)})
  end

  @doc """
  iex> Generator.next_val(65, 16807)
  1092455

  iex> Generator.next_val(1092455, 16807)
  1181022009

  iex> Generator.next_val(1181022009, 16807)
  245556042

  iex> Generator.next_val(8921, 48271)
  430625591

  iex> Generator.next_val(430625591, 48271)
  1233683848

  iex> Generator.next_val(1233683848, 48271)
  1431495498
  """
  def next_val(val, factor) do
    rem(val * factor, 2_147_483_647)
  end
end
