defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    str = Integer.to_charlist(number)

    Enum.reduce(str, 0, fn n, s -> s + Integer.pow(n - ?0, length(str)) end) == number
  end
end
