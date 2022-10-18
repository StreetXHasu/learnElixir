defmodule Holiday.Event do
  use Ecto.Schema

  schema "holiday" do
    field(:title, :string)
    field(:dStart, :date)
    field(:dEnd, :date)
    field(:uid, :binary_id)
    field(:rules, :map)
    field(:isConfirmed, :boolean)
  end
end
