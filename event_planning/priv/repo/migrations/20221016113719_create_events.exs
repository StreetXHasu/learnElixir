defmodule EventPlanning.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :text
      add :dStart, :naive_datetime
      add :dEnd, :naive_datetime
      add :isActive, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing), null: true

      timestamps()
    end

    create index(:events, [:user_id])
  end
end
