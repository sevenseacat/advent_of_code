defmodule Y2016.Day10.Bot do
  defstruct status: :pending,
            holding: [],
            low_to: nil,
            high_to: nil,
            comparisons: nil

  def new(), do: %__MODULE__{comparisons: MapSet.new()}

  def drop_pieces(%__MODULE__{} = bot, comparison) do
    bot
    |> Map.put(:status, :done)
    |> Map.put(:holding, [])
    |> Map.update!(:comparisons, &MapSet.put(&1, comparison))
  end

  def hold(%__MODULE__{} = bot, value) do
    bot
    |> Map.put(:status, :pending)
    |> Map.update!(:holding, &[maybe_int(value) | &1])
  end

  def set_rule(%__MODULE__{} = bot, low_to, high_to) do
    %{bot | high_to: high_to, low_to: low_to}
  end

  def made_comparison?(%__MODULE__{} = bot, comparison) do
    Enum.member?(bot.comparisons, comparison)
  end

  def made_comparison?(_, _), do: false

  defp maybe_int(value) when is_integer(value), do: value
  defp maybe_int(value) when is_binary(value), do: String.to_integer(value)
end
