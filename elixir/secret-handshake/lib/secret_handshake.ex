defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    actions =
      code
      |> Integer.digits(2)
      |> Enum.reverse()
      |> Enum.take(4)
      |> Enum.zip(["wink", "double blink", "close your eyes", "jump"])
      |> Enum.filter(fn
        {1, _} -> true
        {0, _} -> false
      end)
      |> Enum.map(fn {_, action} -> action end)

    if Bitwise.&&&(code, 0b10000) != 0 do
      Enum.reverse(actions)
    else
      actions
    end
  end
end
