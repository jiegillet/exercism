defmodule Forth do
  @opaque evaluator :: %{stack: [integer], ops: %{String.t() => [atom] | [String.t()]}}

  @doc """
  Create a new evaluator.
  """

  @basic_ops %{
    "dup" => [:dup],
    "drop" => [:drop],
    "swap" => [:swap],
    "over" => [:over],
    "+" => [:+],
    "-" => [:-],
    "*" => [:*],
    "/" => [:/]
  }

  @spec new() :: evaluator
  def new() do
    %{stack: [], ops: @basic_ops}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    String.downcase(s)
    |> tokenize()
    |> evaluate(ev)
  end

  @separator ~r/[\s \x00-\x19]/

  def tokenize(string) do
    string
    |> String.split(@separator, trim: true)
    |> Enum.map(&parse_integer/1)
  end

  def parse_integer(word) do
    case Integer.parse(word) do
      {int, ""} -> int
      _ -> word
    end
  end

  # End of input
  def evaluate([], ev), do: ev

  # Integer input
  def evaluate([i | tokens], %{stack: stack} = ev) when is_number(i),
    do: evaluate(tokens, %{ev | stack: [i | stack]})

  # Stack manipulation
  def evaluate([op | tokens], %{stack: stack} = ev) when is_atom(op) do
    new_stack =
      case {op, stack} do
        {:+, [a, b | rest]} -> [a + b | rest]
        {:-, [a, b | rest]} -> [b - a | rest]
        {:*, [a, b | rest]} -> [a * b | rest]
        {:/, [0 | _rest]} -> raise __MODULE__.DivisionByZero
        {:/, [a, b | rest]} -> [div(b, a) | rest]
        {:dup, [a | rest]} -> [a, a | rest]
        {:drop, [_a | rest]} -> rest
        {:swap, [a, b | rest]} -> [b, a | rest]
        {:over, [a, b | rest]} -> [b, a, b | rest]
        {_op, _stack} -> raise __MODULE__.StackUnderflow
      end

    evaluate(tokens, %{ev | stack: new_stack})
  end

  # New words
  def evaluate([":" | tokens], %{ops: ops} = ev) do
    [name | instructions] = Enum.take_while(tokens, fn t -> t != ";" end)

    if is_number(name) do
      raise __MODULE__.InvalidWord, word: name
    else
      rest = tokens |> Enum.drop_while(fn t -> t != ";" end) |> tl
      new_ops = Map.put(ops, name, instructions)

      evaluate(rest, %{ev | ops: new_ops})
    end
  end

  # Check for known words
  def evaluate([token | tokens], %{ops: ops} = ev) do
    if not Map.has_key?(ops, token) do
      raise __MODULE__.UnknownWord, word: token
    else
      evaluate(ops[token] ++ tokens, ev)
    end
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%{stack: stack}) do
    stack
    |> Enum.reverse()
    |> Enum.map_join(" ", &Integer.to_string/1)
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
