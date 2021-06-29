defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  defguard valid?(a, b) when 0 <= a and a <= 7 and 0 <= b and b <= 7

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(positions) do
    case {positions[:white], positions[:black]} do
      {{a, b}, nil} when valid?(a, b) ->
        %Queens{white: {a, b}}

      {nil, {a, b}} when valid?(a, b) ->
        %Queens{black: {a, b}}

      {{a, b}, {c, d}} when {a, b} != {c, d} and valid?(a, b) and valid?(c, d) ->
        %Queens{white: {a, b}, black: {c, d}}

      _ ->
        raise ArgumentError
    end
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{black: pos_b, white: pos_w}) do
    Enum.map_join(0..7, "\n", fn
      row ->
        Enum.map_join(0..7, " ", fn
          col ->
            cond do
              {row, col} == pos_b -> "B"
              {row, col} == pos_w -> "W"
              true -> "_"
            end
        end)
    end)
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {bx, by}, white: {wx, wy}}) do
    bx == wx or by == wy or abs(bx - wx) == abs(by - wy)
  end

  def can_attack?(_queen), do: false
end
