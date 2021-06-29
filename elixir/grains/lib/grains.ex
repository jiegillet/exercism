defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) do
    if 1 <= number and number <= 64 do
      {:ok, Integer.pow(2, number - 1)}
    else
      {:error, "The requested square must be between 1 and 64 (inclusive)"}
    end
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    # The sum of a finite geometric series has a closed formula
    # div( a * (1 - Integer.pow(r, n)) 1 - r)
    # n is the number of terms (64)
    # a is the first term (1)
    # r is the common ratio (2)
    {:ok, Integer.pow(2, 64) - 1}
  end
end
