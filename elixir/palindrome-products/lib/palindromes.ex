defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    for i <- min_factor..max_factor, j <- min_factor..max_factor, i <= j, is_palindrome?(i * j) do
      {i * j, [i, j]}
    end
    |> Enum.reduce(%{}, fn {product, factor}, map ->
      Map.update(map, product, [factor], fn old -> [factor | old] end)
    end)
  end

  def is_palindrome?(n) do
    s = Integer.to_string(n)
    s == String.reverse(s)
  end
end
