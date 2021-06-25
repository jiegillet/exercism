defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  defmodule Robot do
    defstruct direction: :north, position: {0, 0}

    @type t :: %Robot{direction: atom, position: {integer, integer}}
  end

  defguard is_position(x, y) when is_integer(x) and is_integer(y)

  @spec create(direction :: atom, position :: {integer, integer}) :: Robot.t() | {atom, String.t()}
  def create(), do: %Robot{}

  def create(direction, {x, y} = position) when is_position(x, y) do
    if direction in [:north, :south, :east, :west] do
      %Robot{direction: direction, position: position}
    else
      {:error, "invalid direction"}
    end
  end

  def create(_direction, _position), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(Robot.t(), instructions :: String.t()) :: Robot.t() | {atom, String.t()}
  def simulate(%Robot{} = robot, instructions) do
    instructions
    |> to_charlist
    |> Enum.reduce(robot, &move/2)
  end

  defp move(?A, %Robot{direction: :north, position: {x, y}} = robot), do: %{robot | position: {x, y + 1}}
  defp move(?A, %Robot{direction: :south, position: {x, y}} = robot), do: %{robot | position: {x, y - 1}}
  defp move(?A, %Robot{direction: :east, position: {x, y}} = robot), do: %{robot | position: {x + 1, y}}
  defp move(?A, %Robot{direction: :west, position: {x, y}} = robot), do: %{robot | position: {x - 1, y}}

  defp move(?R, %Robot{direction: :north} = robot), do: %{robot | direction: :east}
  defp move(?R, %Robot{direction: :south} = robot), do: %{robot | direction: :west}
  defp move(?R, %Robot{direction: :east} = robot), do: %{robot | direction: :south}
  defp move(?R, %Robot{direction: :west} = robot), do: %{robot | direction: :north}

  defp move(?L, %Robot{direction: :north} = robot), do: %{robot | direction: :west}
  defp move(?L, %Robot{direction: :south} = robot), do: %{robot | direction: :east}
  defp move(?L, %Robot{direction: :east} = robot), do: %{robot | direction: :north}
  defp move(?L, %Robot{direction: :west} = robot), do: %{robot | direction: :south}

  defp move(_instruction, _maybe_robot), do: {:error, "invalid instruction"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: Robot.t()) :: atom
  def direction(%Robot{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: Robot.t()) :: {integer, integer}
  def position(%Robot{position: position}), do: position
end
