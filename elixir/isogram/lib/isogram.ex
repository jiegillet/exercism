defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.replace(~r/[ -]/, "")
    |> to_charlist
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.all?(&(&1 == 1))
  end
end
