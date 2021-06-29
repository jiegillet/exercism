defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    String.split(str, "\n")
    |> Enum.map(fn row -> row |> String.split() |> Enum.map(&String.to_integer/1) end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rows(str) |> transpose
  end

  def transpose(matrix) do
    if Enum.any?(matrix, fn row -> length(row) == 0 end) do
      []
    else
      col = Enum.map(matrix, &hd/1)

      [col | matrix |> Enum.map(&tl/1) |> transpose]
    end
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    rows = rows(str)
    columns = transpose(rows)

    maxima = Enum.map(rows, &Enum.max/1)
    minima = Enum.map(columns, &Enum.min/1)

    Enum.zip_with([rows, maxima, 0..length(rows)], fn
      [row, max, r] ->
        Enum.zip_with([row, minima, 0..length(row)], fn [el, min, c] ->
          if el == max and el == min do
            {r, c}
          else
            nil
          end
        end)
    end)
    |> Enum.concat()
    |> Enum.reject(&is_nil/1)
  end
end
