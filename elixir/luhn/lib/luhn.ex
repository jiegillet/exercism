defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number = String.replace(number, " ", "")

    cond do
      String.match?(number, ~r/[^0-9]/) -> false
      String.length(number) <= 1 -> false
      true -> luhn(number)
    end
  end

  defp luhn(number) do
    checksum =
      (number <> "0")
      |> to_charlist
      |> Enum.reverse()
      |> Enum.map(fn char -> char - ?0 end)
      |> Enum.map_every(2, fn
        n when n <= 4 -> 2 * n
        n -> 2 * n - 9
      end)
      |> Enum.sum()

    rem(checksum, 10) == 0
  end
end
