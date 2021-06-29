defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]), do: true

  def chain?([{a, b} | dominoes]) do
    chain?(a, b, dominoes)
  end

  def chain?(start, tail, []), do: start == tail

  def chain?(start, tail, dominoes) do
    dominoes
    |> Enum.filter(fn {a, b} -> a == tail or b == tail end)
    |> Enum.any?(fn {a, b} = d ->
      chain?(start, if(a == tail, do: b, else: a), dominoes -- [d])
    end)
  end
end
