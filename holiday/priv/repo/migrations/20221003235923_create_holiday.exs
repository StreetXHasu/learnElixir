defmodule Holiday.Repo.Migrations.CreateHoliday do
  use Ecto.Migration

  def change do
    create table(:holiday) do
      add(:name, :string, null: false)
      add(:age, :integer, default: 0)
    end
  end
end
