defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base_sorted = sort(base)

    candidates
    |> Enum.filter(fn word ->
      sort(word) == base_sorted and
        String.downcase(word) != String.downcase(base)
    end)
  end

  def sort(word) do
    word
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.sort()
  end
end
