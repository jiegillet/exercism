defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @weekdays {:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday}

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    {:ok, start} = Date.new(year, month, 1)
    stop = Date.end_of_month(start)

    Date.range(start, stop)
    |> Enum.filter(fn day -> elem(@weekdays, Date.day_of_week(day) - 1) == weekday end)
    |> match_schedule(schedule)
  end

  def match_schedule([first, second, third | others] = dates, schedule) do
    case schedule do
      :first ->
        first

      :second ->
        second

      :third ->
        third

      :fourth ->
        List.first(others)

      :last ->
        List.last(others)

      :teenth ->
        dates
        |> Enum.filter(fn %{day: day} -> day in 13..19 end)
        |> List.first()
    end
  end
end
