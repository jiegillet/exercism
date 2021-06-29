defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @numbers %{
    [' _ ', '| |', '|_|', '   '] => "0",
    ['   ', '  |', '  |', '   '] => "1",
    [' _ ', ' _|', '|_ ', '   '] => "2",
    [' _ ', ' _|', ' _|', '   '] => "3",
    ['   ', '|_|', '  |', '   '] => "4",
    [' _ ', '|_ ', ' _|', '   '] => "5",
    [' _ ', '|_ ', '|_|', '   '] => "6",
    [' _ ', '  |', '  |', '   '] => "7",
    [' _ ', '|_|', '|_|', '   '] => "8",
    [' _ ', '|_|', ' _|', '   '] => "9"
  }

  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, charlist()}
  def convert([r1, _r2, _r3, _r4] = input) do
    size = String.length(r1)

    if rem(size, 3) == 0 and Enum.all?(input, fn r -> String.length(r) == size end) do
      number =
        input
        |> Enum.map(&to_charlist/1)
        |> Enum.map(&Enum.chunk_every(&1, 3))
        |> Enum.zip_with(fn char -> Map.get(@numbers, char, "?") end)
        |> Enum.join()

      {:ok, number}
    else
      {:error, 'invalid column count'}
    end
  end

  def convert(input) when rem(length(input), 4) != 0 do
    {:error, 'invalid line count'}
  end

  def convert(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&convert/1)
    |> Enum.reduce({:ok, ""}, fn
      {:ok, numbers}, {:ok, ""} -> {:ok, numbers}
      {:ok, numbers}, {:ok, string} -> {:ok, string <> "," <> numbers}
      {:error, err}, _string -> {:error, err}
      _, {:error, err} -> {:error, err}
    end)
  end
end
