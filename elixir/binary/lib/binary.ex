defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    string
    |> to_charlist
    |> Enum.reduce_while(0, fn
      ?0, acc -> {:cont, 2 * acc}
      ?1, acc -> {:cont, 2 * acc + 1}
      _, _ -> {:halt, 0}
    end)
  end
end
