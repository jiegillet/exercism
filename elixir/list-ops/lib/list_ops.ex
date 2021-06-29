defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([head | tail], acc, f), do: f.(head, reduce(tail, acc, f))

  # def reduce_left([], acc, _f), do: acc
  # def reduce_left([head | tail], acc, f), do: reduce_left(tail, f.(head, acc), f)

  def reduce_left(l, acc, f) do
    composed_f =
      reduce(
        l,
        fn x -> x end,
        fn list_el, composed -> fn accel -> composed.(f.(list_el, accel)) end end
      )

    composed_f.(acc)
  end

  @spec count(list) :: non_neg_integer
  def count(l), do: reduce(l, 0, fn _a, n -> n + 1 end)

  @spec reverse(list) :: list
  def reverse(l), do: reduce_left(l, [], fn a, lst -> [a | lst] end)

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: reduce(l, [], fn a, lst -> [f.(a) | lst] end)

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: reduce(l, [], fn a, lst -> if f.(a), do: [a | lst], else: lst end)

  @spec append(list, list) :: list
  def append(a, b), do: reduce(a, b, fn x, lst -> [x | lst] end)

  @spec concat([[any]]) :: [any]
  def concat(ll), do: reduce(ll, [], &append/2)
end
