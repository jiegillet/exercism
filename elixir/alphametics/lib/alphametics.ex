defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

      iex> Alphametics.solve("I + BB == ILL")
      %{?I => 1, ?B => 9, ?L => 0}

      iex> Alphametics.solve("A == B")
      nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    {total, terms} =
      puzzle
      |> String.split(~r/ \+ | \=\= /)
      |> Enum.map(&to_charlist/1)
      |> List.pop_at(-1)

    leading = [hd(total) | Enum.map(terms, &hd/1)] |> Enum.uniq()
    letters = Enum.uniq(to_charlist(puzzle)) -- [?+, ?=, ?\s | leading]

    create_permutations(leading, letters)
    |> Enum.find(&check_sum(terms, total, &1))
  end

  def create_permutations(leading, letters, taken \\ [])
  def create_permutations([], [], _taken), do: [%{}]

  def create_permutations([head | leading], letters, taken) do
    for val <- Enum.to_list(1..9) -- taken,
        perm <- create_permutations(leading, letters, [val | taken]) do
      Map.put(perm, head, val)
    end
  end

  def create_permutations([], [head | letters], taken) do
    for val <- Enum.to_list(0..9) -- taken,
        perm <- create_permutations([], letters, [val | taken]) do
      Map.put(perm, head, val)
    end
  end

  def check_sum(terms, total, values) do
    to_int(total, values) == terms |> Enum.map(&to_int(&1, values)) |> Enum.sum()
  end

  def to_int(letters, values) do
    Enum.reduce(letters, 0, fn l, n -> 10 * n + Map.get(values, l) end)
  end
end
