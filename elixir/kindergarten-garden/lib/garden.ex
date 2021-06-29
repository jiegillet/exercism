defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @names ~w"alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry"a

  @plants %{?G => :grass, ?V => :violets, ?R => :radishes, ?C => :clover}

  @spec info(String.t(), list) :: map
  def info(info_string), do: info(info_string, @names, :sorted)
  def info(info_string, student_names), do: info(info_string, Enum.sort(student_names), :sorted)

  def info(info_string, student_names, :sorted) do
    [row1, row2] =
      info_string
      |> String.split("\n")
      |> Enum.map(&to_charlist/1)

    student_names
    |> Map.new(fn name -> {name, {}} end)
    |> assign_plants(student_names, row1, row2)
  end

  defp assign_plants(assignment, _, [], []), do: assignment

  defp assign_plants(assignment, [name | names], [a | [b | row1]], [c | [d | row2]]) do
    plants =
      [a, b, c, d]
      |> Enum.map(&Map.get(@plants, &1))
      |> List.to_tuple()

    assignment
    |> Map.put(name, plants)
    |> assign_plants(names, row1, row2)
  end
end
