defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    solutions = %{0 => []}
    do_generate(coins, target, solutions)
  end

  def do_generate(coins, target, solutions) do
    cond do
      solutions == %{} ->
        {:error, "cannot change"}

      Map.has_key?(solutions, target) ->
        {:ok, Enum.sort(solutions[target])}

      true ->
        solutions = new_solutions(coins, target, solutions)
        do_generate(coins, target, solutions)
    end
  end

  defp new_solutions(coins, target, solutions) do
    for coin <- coins,
        {total, change} <- solutions,
        not Map.has_key?(solutions, total + coin),
        total + coin <= target,
        into: %{} do
      {total + coin, [coin | change]}
    end
  end
end
