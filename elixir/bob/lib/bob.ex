defmodule Bob do
  def hey(input) do
    input = String.trim(input)
    blank = input == ""
    question = String.ends_with?(input, "?")
    shouting = input == String.upcase(input) and input != String.downcase(input)

    cond do
      blank -> "Fine. Be that way!"
      shouting and question -> "Calm down, I know what I'm doing!"
      shouting -> "Whoa, chill out!"
      question -> "Sure."
      true -> "Whatever."
    end
  end
end
