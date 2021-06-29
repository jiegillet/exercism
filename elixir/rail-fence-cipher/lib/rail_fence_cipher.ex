defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str

  def encode(str, rails) do
    size = String.length(str)
    step = 2 * (rails - 1)

    rows =
      for row <- 0..(rails - 1) do
        for i <- row..(size - 1)//step do
          cond do
            # First row
            row == 0 ->
              String.at(str, i)

            # Last row
            row == step - row ->
              String.at(str, i)

            # Middle row, with second pass still in the string
            i + step - 2 * row < size ->
              [String.at(str, i), String.at(str, i + step - 2 * row)]

            # Middle row, with no second pass
            true ->
              String.at(str, i)
          end
        end
      end

    to_string(rows)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    size = String.length(str)
    step = 2 * (rails - 1)

    str
    |> to_charlist
    |> Enum.reduce({[], [], 0, 0, false}, fn char, {buffer, text, row, index, wait} ->
      cond do
        wait and index < size -> {[char | buffer], text, row, index, false}
        index < size -> {[char | buffer], text, row, index + step, false}
        row == 0 -> {[], [[char | buffer] | text], row + 1, row + 1, false}
        row == rails - 1 -> {[], [[char | buffer] | text], text, row, index, wait}
        true -> {[], [[char | buffer] | text], row + 1, row + 1, true}
      end
    end)

    #    str
    #    |> to_charlist
    #    |> Enum.zip(0..(size - 1))
    #    |> Enum.reduce(%{}, fn {char, index}, rows ->
    #      row = rem(index, step)
    #
    #  row =
    #     if row > rails - 1 do
    #      step - row
    #   else
    #    row
    # end

    #   IO.inspect({[char], index, row})

    #  Map.update(rows, row, [char], fn s -> [char | s] end)
    #   end)
  end
end
