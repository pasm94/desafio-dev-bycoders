defmodule Backend.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :integer, null: false
      add :date, :date, null: false
      add :value, :integer, null: false
      add :cpf, :string, null: false
      add :card, :string, null: false
      add :hour, :time, null: false
      add :store_owner, :string, null: false
      add :store, :string, null: false
    end
  end
end
