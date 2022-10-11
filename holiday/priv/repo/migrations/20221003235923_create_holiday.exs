defmodule Holiday.Repo.Migrations.CreateHoliday do
  use Ecto.Migration

  def change do
    create table(:holiday) do
      add(:title, :string, null: true)
      add(:dStart, :date, null: true)
      add(:dEnd, :date, null: true)
      add(:uid, :binary_id, autogenerate: true)
      add(:rules, :map, null: true)
      add(:isConfirmed, :boolean, default: false)
    end

    create(unique_index(:holiday, [:uid, :uid]))
  end
end
