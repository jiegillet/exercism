defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(dimension), do: matrix(dimension, 1)
  def matrix(0, _from), do: [[]]
  def matrix(1, from), do: [[from]]

  def matrix(dimension, from) do
    up = Enum.to_list(from..(from + dimension - 1)//1)
    right = Enum.to_list((from + dimension)..(from + 2 * dimension - 3)//1)
    down = Enum.to_list((from + 3 * dimension - 3)..(from + 2 * dimension - 2)//-1)
    left = Enum.to_list((from + 4 * dimension - 5)..(from + 3 * dimension - 2)//-1)

    inner = matrix(dimension - 2, from + 4 * dimension - 4)

    [inner, left, right]
    |> Enum.zip_with(fn [row, l, r] -> pad(row, l, r) end)
    |> pad(up, down)
  end

  def pad(inner, left, right), do: [left | inner] ++ [right]
end
