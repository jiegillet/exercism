defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.
  import Kernel, except: [length: 1]

  @type acc :: any

  @spec length(list) :: integer
  def length([]), do: 0
  def length([_head | tail]), do: 1 + length(tail)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _f), do: acc
  def foldr([head | tail], acc, f), do: f.(head, foldr(tail, acc, f))

  def foldl([], acc, _f), do: acc
  def foldl([head | tail], acc, f), do: foldl(tail, f.(head, acc), f)

  @spec count(list) :: non_neg_integer
  def count(l), do: foldr(l, 0,fn _a, n -> n + 1 end)

  @spec reverse(list) :: list
  def reverse(l), do: foldl(l, [], fn a, lst -> [a | lst] end)

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: foldr(l, [], fn a, lst -> [f.(a) | lst] end)

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: foldr(l, [], fn a, lst -> if f.(a), do: [a | lst], else: lst end)

  @spec append(list, list) :: list
  def append(a, b), do: foldr(a, b, fn x, lst -> [x | lst] end)

  @spec concat([[any]]) :: [any] 
  def concat(ll), do: foldr(ll, [], &append/2)
end
