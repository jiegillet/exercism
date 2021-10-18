defmodule Dot do
  defmacro graph(do: ast) do
    args =
      case ast do
        {:__block__, _metadata, args} -> args
        _ -> [ast]
      end

    Enum.reduce(
      args,
      %Graph{},
      fn ast, %Graph{attrs: attrs, edges: edges, nodes: nodes} = graph ->
        case ast do
          {:graph, _metadata, args} ->
            %{graph | attrs: Map.merge(attrs, check_args(args))}

          {:--, _metadata, [{a, _, nil}, {b, _, args}]} ->
            %{
              graph
              | edges: [{a, b, check_args(args)} | edges],
                nodes:
                  nodes
                  |> Map.update(a, %{}, & &1)
                  |> Map.update(b, %{}, & &1)
            }

          {name, _metadata, args} ->
            %{graph | nodes: Map.put(nodes, name, check_args(args))}

          _ ->
            raise ArgumentError
        end
      end
    )
    |> Macro.escape()
  end

  def check_args(nil), do: %{}

  def check_args([args]),
    do: if(Keyword.keyword?(args), do: Enum.into(args, %{}), else: raise(ArgumentError))

  def check_args(_args), do: raise(ArgumentError)
end
