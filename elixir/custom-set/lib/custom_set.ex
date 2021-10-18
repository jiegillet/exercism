defmodule CustomSet do
  alias CustomSet, as: Set

  defstruct [:value, :left, :right, size: 0]

  @opaque t ::
            %Set{value: nil, left: nil, right: nil, size: 0}
            | %Set{value: any, left: t, right: t, size: pos_integer}

  @spec new(Enum.t()) :: t
  def new(enumerable), do: Enum.reduce(enumerable, %Set{}, &add(&2, &1))

  @spec empty?(t) :: boolean
  def empty?(%Set{size: 0}), do: true
  def empty?(_set), do: false

  @spec contains?(t, any) :: boolean
  def contains?(%Set{size: 0}, _element), do: false
  def contains?(%Set{value: element}, element), do: true

  def contains?(%Set{value: value, left: left}, element) when element < value do
    contains?(left, element)
  end

  def contains?(%Set{right: right}, element), do: contains?(right, element)

  @spec equal?(t, t) :: boolean
  def equal?(%Set{size: 0}, %Set{size: 0}), do: true

  def equal?(set_a, %Set{value: b, left: l_b, right: r_b} = set_b)
      when set_a.size == set_b.size do
    case split_at(set_a, b) do
      {smaller, true, larger} -> equal?(smaller, l_b) and equal?(larger, r_b)
      _ -> false
    end
  end

  def equal?(_, _), do: false

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%Set{size: 0}, _set_b), do: true
  def disjoint?(_set_a, %Set{size: 0}), do: true

  def disjoint?(%Set{value: a, left: l_a, right: r_a}, set_b) do
    case split_at(set_b, a) do
      {smaller, false, larger} -> disjoint?(l_a, smaller) and disjoint?(r_a, larger)
      _ -> false
    end
  end

  @spec subset?(t, t) :: boolean
  def subset?(%Set{size: 0}, _set_b), do: true

  def subset?(%Set{value: a, left: l_a, right: r_a} = set_a, set_b)
      when set_a.size <= set_b.size do
    case split_at(set_b, a) do
      {smaller, true, larger} -> subset?(l_a, smaller) and subset?(r_a, larger)
      _ -> false
    end
  end

  def subset?(_set_a, _set_b), do: false

  @spec add(t, any) :: t
  def add(%Set{size: 0}, element), do: %Set{value: element, size: 1, left: %Set{}, right: %Set{}}
  def add(%Set{value: element} = set, element), do: set

  def add(%Set{value: value, left: left, right: right} = tree, element) when element < value do
    left = add(left, element)
    %{tree | size: left.size + right.size + 1, left: left}
  end

  def add(%Set{left: left, right: right} = tree, element) do
    right = add(right, element)
    %{tree | size: left.size + right.size + 1, right: right}
  end

  @spec intersection(t, t) :: t
  def intersection(%Set{size: 0}, _set), do: %Set{}
  def intersection(_set, %Set{size: 0}), do: %Set{}

  def intersection(%Set{value: a, left: l_a, right: r_a}, set_b) do
    {smaller, found, larger} = split_at(set_b, a)
    left = intersection(l_a, smaller)
    right = intersection(r_a, larger)

    if found do
      %Set{value: a, left: left, right: right, size: left.size + right.size + 1}
    else
      union(left, right)
    end
  end

  @spec difference(t, t) :: t
  def difference(%Set{size: 0}, _set), do: %Set{}
  def difference(set, %Set{size: 0}), do: set

  def difference(%Set{value: a, left: l_a, right: r_a}, set_b) do
    {smaller, found, larger} = split_at(set_b, a)
    left = difference(l_a, smaller)
    right = difference(r_a, larger)

    if found do
      union(left, right)
    else
      %Set{value: a, left: left, right: right, size: left.size + right.size + 1}
    end
  end

  @spec union(t, t) :: t
  def union(%Set{size: 0}, set), do: set
  def union(set, %Set{size: 0}), do: set

  def union(%Set{value: a, left: l_a, right: r_a}, set_b) do
    {smaller, _found, larger} = split_at(set_b, a)
    left = union(l_a, smaller)
    right = union(r_a, larger)
    %Set{value: a, left: left, right: right, size: left.size + right.size + 1}
  end

  @spec split_at(t, any) :: {t, boolean, t}
  defp split_at(%Set{size: 0}, _pivot), do: {%Set{}, false, %Set{}}

  defp split_at(%Set{value: pivot, left: left, right: right}, pivot) do
    {left, true, right}
  end

  defp split_at(%Set{value: value, left: left, right: right} = set, pivot) when pivot < value do
    {smaller, pivot, larger} = split_at(left, pivot)
    {smaller, pivot, %{set | left: larger, size: right.size + larger.size + 1}}
  end

  defp split_at(%Set{left: left, right: right} = set, pivot) do
    {smaller, found, larger} = split_at(right, pivot)
    {%{set | right: smaller, size: left.size + smaller.size + 1}, found, larger}
  end
end
