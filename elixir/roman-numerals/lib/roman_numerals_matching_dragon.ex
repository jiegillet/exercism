defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()

  @roman %{
    1000 => "M",
    900 => "CM",
    500 => "D",
    400 => "CD",
    100 => "C",
    90 => "XC",
    50 => "L",
    40 => "XL",
    10 => "X",
    9 => "IX",
    5 => "V",
    4 => "IV",
    1 => "I"
  }

  def numeral(0), do: ""

  for {arab, roman} <- Enum.reverse(@roman) do
    def numeral(number) when number >= unquote(arab),
      do: unquote(roman) <> numeral(number - unquote(arab))
  end
end
