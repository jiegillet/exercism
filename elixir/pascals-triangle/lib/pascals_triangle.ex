defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(0), do: []
  def rows(num), do: rows(num - 1, [[1]]) |> Enum.reverse()

  def rows(0, triangle), do: triangle

  def rows(num, [row | triangle]) do
    new_row = Enum.zip_with([0 | row], row ++ [0], &+/2)
    rows(num - 1, [new_row, row | triangle])
  end
end
