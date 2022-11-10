defmodule EventPlanning.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :text
      add :date_start, :naive_datetime
      add :date_end, :naive_datetime
      add :repeat, :integer, default: 0, null: false
      add :repeat_days_week, {:array, :string}, default: nil, null: true
      add :repeat_date_end, :naive_datetime, default: nil, null: true
      add :user_id, references(:users, on_delete: :nothing), null: true

      timestamps()
    end

    create index(:events, [:user_id])
  end
end
