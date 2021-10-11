defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) when limit < 2, do: []

  def primes_to(limit) do
    do_primes(Enum.to_list(2..limit), [])
  end

  def do_primes([], primes), do: Enum.reverse(primes)
  def do_primes([nil | sieve], primes), do: do_primes(sieve, primes)

  def do_primes([prime | _] = sieve, primes) do
    sieve =
      sieve
      |> Enum.chunk_every(prime)
      |> Enum.map(fn [_ | tail] -> [nil | tail] end)
      |> Enum.concat()

    do_primes(sieve, [prime | primes])
  end
end
