defmodule EventPlanning.Accounts.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :description, :string
    field :date_start, :naive_datetime
    field :date_end, :naive_datetime

    field :repeat, Ecto.Enum, values: [disabled: 0, day: 1, month: 2, week: 3, year: 4]

    field :repeat_days_week, {:array, :string}, default: nil

    field :repeat_date_end, :naive_datetime

    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :description,
      :date_start,
      :date_end,
      :repeat,
      :repeat_days_week,
      :repeat_date_end,
      :user_id
    ])
    |> validate_required([
      :date_start,
      :date_end
    ])
  end
end
