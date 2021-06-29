defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(element) when not(is_list(element)), do: [element]
  def flatten(list) do
    list
    |> Enum.map(&flatten/1)
    |> Enum.concat()
    |> Enum.reject(&is_nil/1)
  end
end
