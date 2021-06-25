defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game

    There are several possible states of the game:
     * :ball_1                  means waiting for the first roll of the frame
     * {:ball_2, roll_1}        means waiting for the second roll of the frame after a first roll_1 < 10
     * :spare                   means waiting for the first roll of the frame after a spare
     * :strike                  means waiting for the first roll of the frame after a strike
     * {:strike, :strike}       means waiting for the first roll of the frame after two consecutive strikes
     * {:strike, roll_1}        means waiting for the second roll of the frame after a strike and a first roll_1 < 10
     * {:strike_fill, roll_1}   means waiting for a second fill ball
     * :fill_done               means there are no more fill balls expected
  """

  @max_pins 10
  @frames 10

  @spec start() :: any
  def start do
    %{score: 0, frame: 1, state: :ball_1}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  # Invalid number of pins
  def roll(_game, roll) when roll < -0,
    do: {:error, "Negative roll is invalid"}

  def roll(_game, roll) when roll > @max_pins,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%{state: {:ball_2, roll_1}}, roll_2) when roll_1 + roll_2 > @max_pins,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%{state: {:strike, roll_1}}, roll_2) when roll_1 + roll_2 > @max_pins,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%{state: {:strike_fill, roll_1}}, roll_2)
      when roll_1 != @max_pins and roll_1 + roll_2 > @max_pins,
      do: {:error, "Pin count exceeds pins on the lane"}

  # Fill balls
  def roll(%{frame: frame, state: :strike} = game, roll) when frame > @frames,
    do: %{game | state: {:strike_fill, roll}}

  def roll(%{frame: frame, score: score, state: {:strike, :strike}} = game, roll)
      when frame > @frames,
      do: %{game | score: score + 2 * @max_pins + roll, state: {:strike_fill, roll}}

  def roll(%{frame: frame, score: score, state: {:strike_fill, roll_1}} = game, roll_2)
      when frame > @frames,
      do: %{game | score: score + @max_pins + roll_1 + roll_2, state: :fill_done}

  def roll(%{frame: frame, score: score, state: :spare} = game, roll) when frame > @frames,
    do: %{game | score: score + @max_pins + roll, state: :fill_done}

  # Too many rolls 
  def roll(%{frame: frame}, _roll) when frame > @frames,
    do: {:error, "Cannot roll after game is over"}

  # Game scoring
  def roll(%{frame: frame, state: :ball_1} = game, @max_pins),
    do: %{game | frame: frame + 1, state: :strike}

  def roll(%{state: :ball_1} = game, roll), do: %{game | state: {:ball_2, roll}}

  def roll(%{frame: frame, state: {:ball_2, roll_1}} = game, roll_2)
      when roll_1 + roll_2 == @max_pins,
      do: %{game | frame: frame + 1, state: :spare}

  def roll(%{frame: frame, score: score, state: {:ball_2, roll_1}} = game, roll_2),
    do: %{game | frame: frame + 1, score: score + roll_1 + roll_2, state: :ball_1}

  def roll(%{frame: frame, score: score, state: :spare} = game, @max_pins),
    do: %{game | frame: frame + 1, score: score + 2 * @max_pins, state: :strike}

  def roll(%{score: score, state: :spare} = game, roll),
    do: %{game | score: score + @max_pins + roll, state: {:ball_2, roll}}

  def roll(%{frame: frame, state: :strike} = game, @max_pins),
    do: %{game | frame: frame + 1, state: {:strike, :strike}}

  def roll(%{state: :strike} = game, roll), do: %{game | state: {:strike, roll}}

  def roll(%{frame: frame, score: score, state: {:strike, :strike}} = game, @max_pins),
    do: %{game | frame: frame + 1, score: score + 3 * @max_pins, state: {:strike, :strike}}

  def roll(%{score: score, state: {:strike, :strike}} = game, roll),
    do: %{game | score: score + 2 * @max_pins + roll, state: {:strike, roll}}

  def roll(%{frame: frame, score: score, state: {:strike, roll_1}} = game, roll_2)
      when roll_1 + roll_2 == @max_pins,
      do: %{game | frame: frame + 1, score: score + 2 * @max_pins, state: :spare}

  def roll(%{frame: frame, score: score, state: {:strike, roll_1}} = game, roll_2),
    do: %{
      game
      | frame: frame + 1,
        score: score + @max_pins + 2 * (roll_1 + roll_2),
        state: :ball_1
    }

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(%{frame: frame}) when frame < @frames,
    do: {:error, "Score cannot be taken until the end of the game"}

  def score(%{score: score, state: :ball_1}), do: score
  def score(%{score: score, state: :fill_done}), do: score
  def score(%{state: _other}), do: {:error, "Score cannot be taken until the end of the game"}
end
