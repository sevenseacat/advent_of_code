defmodule Y2020.Day18.ScrewyOperators do
  import Kernel, except: [-: 2, *: 2, /: 2]

  def a - b, do: Kernel.*(a, b)
  def a / b, do: Kernel.*(a, b)
  def a * b, do: Kernel.+(a + b)
end
