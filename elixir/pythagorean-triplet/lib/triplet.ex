defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum([a, b, c]), do: a + b + c

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product([a, b, c]), do: a * b * c

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]), do: a * a + b * b == c * c

  @doc """
  Generates a list of pythagorean triplets from a given min (or 1 if no min) to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min \\ 1, max), do: generate([[3, 4, 5]], min, max)
  def generate([], _min, _max), do: []

  def generate([[a, b, c] = triple | triplets], min, max) do
    next =
      (next_triplets(triple) ++ triplets)
      |> Enum.reject(fn [_a, _b, c] -> c > max end)

    multiples =
      1..div(max, c)//1
      |> Enum.map(fn n -> [n * a, n * b, n * c] end)
      |> Enum.reject(fn [a, b, c] -> a < min or b < min end)

    multiples ++ generate(next, min, max)
  end

  def next_triplets([a, b, c]),
    do: [
      [a - 2 * b + 2 * c, 2 * a - b + 2 * c, 2 * a - 2 * b + 3 * c],
      [a + 2 * b + 2 * c, 2 * a + b + 2 * c, 2 * a + 2 * b + 3 * c],
      [-a + 2 * b + 2 * c, -2 * a + b + 2 * c, -2 * a + 2 * b + 3 * c]
    ]

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max, sum) do
    generate(min, max)
    |> Enum.filter(&(Triplet.sum(&1) == sum))
    |> Enum.sort()
  end
end
