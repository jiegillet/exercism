defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list | nil
  def convert(digits, base_a, base_b) do
    cond do
      digits == [] ->
        nil

      base_a <= 1 or base_b <= 1 ->
        nil

      Enum.any?(digits, fn n -> n < 0 or n >= base_a end) ->
        nil

      Enum.all?(digits, fn n -> n == 0 end) ->
        [0]

      true ->
        digits
        |> Enum.reduce(0, fn d, acc -> base_a * acc + d end)
        |> to_base(base_b)
        |> Enum.reverse()
    end
  end

  def to_base(0, _base), do: []

  def to_base(n, base) do
    [rem(n, base) | to_base(div(n, base), base)]
  end
end
