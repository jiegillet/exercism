defmodule Zipper do
  defstruct [:focus, genealogy: []]

  @type t :: %Zipper{
          focus: BinTree.t(),
          genealogy: [{:left, any, BinTree.t()} | {:right, any, BinTree.t()}]
        }

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(%BinTree{} = tree), do: %Zipper{focus: tree}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{focus: tree, genealogy: []}), do: tree
  def to_tree(zipper), do: zipper |> up |> to_tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{focus: %BinTree{value: value}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{focus: %BinTree{left: nil}}), do: nil

  def left(%Zipper{focus: %BinTree{value: value, left: left, right: right}, genealogy: genealogy}) do
    %Zipper{focus: left, genealogy: [{:left, value, right} | genealogy]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{focus: %BinTree{right: nil}}), do: nil

  def right(%Zipper{focus: %BinTree{value: value, left: left, right: right}, genealogy: genealogy}) do
    %Zipper{focus: right, genealogy: [{:right, value, left} | genealogy]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{focus: tree, genealogy: [{:left, node, right} | genealogy]}) do
    %Zipper{focus: %BinTree{value: node, left: tree, right: right}, genealogy: genealogy}
  end

  def up(%Zipper{focus: tree, genealogy: [{:right, node, left} | genealogy]}) do
    %Zipper{focus: %BinTree{value: node, left: left, right: tree}, genealogy: genealogy}
  end

  def up(_zipper), do: nil

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{focus: %BinTree{} = tree} = zipper, value) do
    %Zipper{zipper | focus: %BinTree{tree | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{focus: %BinTree{} = tree} = zipper, left) do
    %Zipper{zipper | focus: %BinTree{tree | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{focus: %BinTree{} = tree} = zipper, right) do
    %Zipper{zipper | focus: %BinTree{tree | right: right}}
  end
end
