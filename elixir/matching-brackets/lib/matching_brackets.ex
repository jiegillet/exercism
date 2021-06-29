defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.replace(~r/[^\[\]\(\)\{\}]/, "")
    |> remove_bracket_pairs()
    |> (&(&1 == "")).()
  end

  @bracket_pair ~r/\(\)|\[\]|\{\}/

  defp remove_bracket_pairs(str) do
    if String.match?(str, @bracket_pair) do
      str
      |> String.replace(@bracket_pair, "")
      |> remove_bracket_pairs
    else
      str
    end
  end
end
