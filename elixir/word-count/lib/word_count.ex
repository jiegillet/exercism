defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.split(~r{[\s,_:\!&@\$%\^&]}, trim: true)
    |> Enum.map(&String.downcase/1)
    |> Enum.reduce(
      %{},
      fn word, zipf -> Map.update(zipf, word, 1, fn c -> c + 1 end) end
    )
  end
end
