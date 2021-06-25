defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    thousands = to_string(for _ <- 1..div(number, 1000)//1, do: ?M)

    number = rem(number, 1000)
    hundreds = units(div(number, 100), ?C, ?D, ?M)

    number = rem(number, 100)
    tens = units(div(number, 10), ?X, ?L, ?C)

    number = rem(number, 10)
    ones = units(number, ?I, ?V, ?X)

    to_string([thousands, hundreds, tens, ones])
  end

  defp units(number, one, five, ten) do
    case number do
      0 -> []
      1 -> [one]
      2 -> [one, one]
      3 -> [one, one, one]
      4 -> [one, five]
      5 -> [five]
      6 -> [five, one]
      7 -> [five, one, one]
      8 -> [five, one, one, one]
      9 -> [one, ten]
    end
  end
end
