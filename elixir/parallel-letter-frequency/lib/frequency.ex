defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """

  @reject_characters ~r/[0-9\s,]/

  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _workers), do: []

  def frequency(texts, workers) do
    texts
    |> Enum.chunk_every(ceil(length(texts) / workers))
    |> Enum.map(fn chunk ->
      Task.async(fn ->
        chunk
        |> Enum.join()
        |> String.replace(@reject_characters, "")
        |> String.downcase()
        |> String.graphemes()
        |> Enum.frequencies()
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(%{}, &Map.merge(&1, &2, fn char, n1, n2 -> n1 + n2 end))
  end
end
