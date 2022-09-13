defmodule Learn2 do
  require Logger

  # [5,4,8,11,null,13,4,7,2,null,null,null,1]
  # 22
  def start do
    null = nil
    has_path_sum([5, 4, 8, 11, null, 13, 4, 7, 2, null, null, null, 1], 22)
  end

  defmodule TreeNode do
    @type t :: %__MODULE__{
            val: integer,
            left: TreeNode.t() | nil,
            right: TreeNode.t() | nil
          }
    defstruct val: 0, left: nil, right: nil
  end

  @spec has_path_sum(root :: TreeNode.t() | nil, target_sum :: integer, count :: integer) ::
          boolean
  def has_path_sum(root, target_sum, count \\ 0)

  def has_path_sum(nil, _, _count), do: false

  def has_path_sum(root, target_sum, _count) do
    cond do
      _count == 0 and root.val == target_sum and root.left == nil and root.right == nil ->
        true

      _count == 0 and root.val == target_sum and (root.left != nil or root.right != nil) ->
        false

      root.val == target_sum and (root.left != nil or root.right != nil) ->
        false

      _count > 0 and root.val == target_sum ->
        true

      target_sum != 0 ->
        has_path_sum(root.left, target_sum - root.val, _count + 1) ||
          has_path_sum(root.right, target_sum - root.val, _count + 1)

      true ->
        false
    end
  end
end
