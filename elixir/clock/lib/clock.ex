defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    minutes = Integer.mod(hour * 60 + minute, 60 * 24)
    %Clock{hour: div(minutes, 60), minute: rem(minutes, 60)}
  end

  defimpl String.Chars, for: Clock do
    def to_string(%Clock{hour: hour, minute: minute}) do
      h = hour |> Integer.to_string() |> String.pad_leading(2, "0")
      m = minute |> Integer.to_string() |> String.pad_leading(2, "0")
      "#{h}:#{m}"
    end
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end
