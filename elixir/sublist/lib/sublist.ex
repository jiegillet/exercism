defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """

  def compare(a, b) do
    l_a = length(a)
    l_b = length(b)

    cond do
      a === b -> :equal
      l_a == l_b -> :unequal
      l_a < l_b -> compare(l_a, a, l_b, b, :original)
      l_b < l_a -> compare(l_b, b, l_a, a, :flipped)
    end
  end

  def compare(_, [], _, _, :original), do: :sublist
  def compare(_, [], _, _, :flipped), do: :superlist

  def compare(l_a, _, l_b, _, _) when l_b < l_a, do: :unequal

  def compare(l_a, [head_a | _] = a, l_b, [head_b | tail_b], order) when head_a != head_b,
    do: compare(l_a, a, l_b - 1, tail_b, order)

  def compare(l_a, a, l_b, b, order) do
    if a === Enum.take(b, l_a) do
      compare(0, [], 0, [], order)
    else
      compare(l_a, a, l_b - 1, Enum.drop(b, 1), order)
    end
  end
end
