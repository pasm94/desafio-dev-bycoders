defmodule Backend.Transactions.Repository.GetByStore do
  alias Backend.Transaction
  alias Backend.Repo

  import Ecto.Query, only: [from: 2]

  def call(store) do
    IO.inspect(store)
    query = from t in Transaction, where: t.store == ^store

    Repo.all(query)
  end
end
