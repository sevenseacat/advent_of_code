defmodule Y2016.Day10.Output do
  defstruct holding: nil, status: :done

  def new(), do: %__MODULE__{}

  def hold(%__MODULE__{} = output, value) do
    %{output | holding: value}
  end
end
