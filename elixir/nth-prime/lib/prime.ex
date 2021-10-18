defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise "there is no zeroth prime"
  def nth(1), do: 2
  def nth(count) do
    do_nth(count - 1, 3, [2])
  end

  def do_nth(0, _n, [prime | _]), do: prime
  def do_nth(count, n, primes) do
    if Enum.any?(primes, fn prime -> rem(n, prime) == 0 end) do
      do_nth(count, n + 2, primes)
    else
      do_nth(count - 1, n + 2, [n | primes])
    end
  end


end
