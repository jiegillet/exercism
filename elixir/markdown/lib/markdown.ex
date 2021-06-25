defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.chunk_by(&list_item?/1)
    |> Enum.map_join(fn
      [line] -> process(line)
      list -> parse_list(list)
    end)
  end

  defp process("#" <> _ = line), do: parse_header_md_level(line)

  defp process(line) do
    paragraph =
      line
      |> String.split()
      |> Enum.map_join(" ", &replace_md_with_tag/1)

    "<p>#{paragraph}</p>"
  end

  defp parse_header_md_level(line) do
    [stars, header] = String.split(line, " ", parts: 2)
    level = String.length(stars)

    "<h#{level}>#{header}</h#{level}>"
  end

  defp list_item?("*" <> _), do: true
  defp list_item?(_), do: false

  defp parse_list(items) do
    list = Enum.map_join(items, &parse_list_md_level/1)

    "<ul>#{list}</ul>"
  end

  defp parse_list_md_level("* " <> line) do
    words =
      line
      |> String.split()
      |> Enum.map_join(" ", &replace_md_with_tag/1)

    "<li>#{words}</li>"
  end

  defp replace_md_with_tag(word) do
    word
    |> String.replace(~r/^__/, "<strong>")
    |> String.replace(~r/__$/, "</strong>")
    |> String.replace(~r/^_/, "<em>")
    |> String.replace(~r/_$/, "</em>")
  end
end
