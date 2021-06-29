defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from({{year, month, day}, {hour, minute, second}}) do
    %NaiveDateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: second} =
      %NaiveDateTime{
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second
      }
      |> NaiveDateTime.add(Integer.pow(10, 9), :second)

    {{year, month, day}, {hour, minute, second}}
  end
end
