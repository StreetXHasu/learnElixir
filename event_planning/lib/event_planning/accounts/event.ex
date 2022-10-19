defmodule EventPlanning.Accounts.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :dEnd, :naive_datetime
    field :dStart, :naive_datetime
    field :description, :string
    field :isActive, :boolean, default: false
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :dStart, :dEnd, :isActive])
    |> validate_required([:name, :description, :dStart, :dEnd, :isActive])
  end
end
