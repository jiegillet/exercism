defmodule Dot do
  defmacro graph(do: ast) do
    args =
      case ast do
        {:__block__, metadata, args} -> args
        _ -> [ast]
      end

    Enum.reduce(
      args,
      %Graph{},
      fn ast, %Graph{attrs: attrs, edges: edges, nodes: nodes} = graph ->
        case ast do
          {:graph, _metadata, args} ->
            %{graph | attrs: check_args(args) ++ attrs}

          {:--, _metadata, [{a, _, nil}, {b, _, args}]} ->
            %{graph | edges: [{a, b, check_args(args)} | edges]}

          {name, _metadata, args} ->
            %{graph | nodes: [{name, check_args(args)} | nodes]}

          _ ->
            raise ArgumentError
        end
      end
    )
    |> sort
    |> Macro.escape()
  end

  def check_args(nil), do: []

  def check_args([args]),
    do: if(Keyword.keyword?(args), do: args, else: raise(ArgumentError))

  def check_args(_args), do: raise(ArgumentError)

  def sort(%Graph{attrs: attrs, edges: edges, nodes: nodes}) do
    %Graph{attrs: Enum.sort(attrs), edges: Enum.sort(edges), nodes: Enum.sort(nodes)}
  end
end
