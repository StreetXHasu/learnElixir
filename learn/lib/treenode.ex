defmodule Learn2 do
  require Logger

  # [5,4,8,11,null,13,4,7,2,null,null,null,1]
  # 22
  def start do
    has_path_sum(
      %{
        val: 5,
        left: nil,
        right: nil
      },
      5
    )
  end

  defmodule TreeNode do
    @type t :: %__MODULE__{
            val: integer,
            left: TreeNode.t() | nil,
            right: TreeNode.t() | nil
          }
    defstruct val: 0, left: nil, right: nil
  end

  @spec has_path_sum(root :: TreeNode.t() | nil, target_sum :: integer) ::
          boolean
  def has_path_sum(root, target_sum) do
    check = root.val == target_sum and root.left == nil and root.right == nil
    IO.puts(check)

    cond do
      root == nil ->
        false

      root.val == target_sum and root.left == nil and root.right == nil ->
        true

      has_path_sum(root.left, target_sum - root.val) ->
        true

      has_path_sum(root.right, target_sum - root.val) ->
        true

      true ->
        false
    end
  end
end
