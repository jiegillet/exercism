defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A), do: "A\n"

  def build_shape(letter) do
    top =
      ?A..letter
      |> Enum.map(&pad(&1, letter))

    bottom =
      top
      |> Enum.reverse()
      |> tl

    Enum.join(top ++ bottom, "\n") <> "\n"
  end

  defp pad(?A, max_letter) do
    <<?A>>
    |> String.pad_leading(max_letter - ?A + 1)
    |> String.pad_trailing(2 * (max_letter - ?A) + 1)
  end

  defp pad(letter, max_letter) do
    left = String.pad_leading(<<letter>>, max_letter - letter + 1)
    right = String.pad_trailing(<<letter>>, max_letter - letter + 1)
    center = String.pad_trailing("", 2 * (letter - ?A) - 1)

    left <> center <> right
  end
end
