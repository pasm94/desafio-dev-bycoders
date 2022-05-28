defmodule Backend.Transactions.Repository.GetByStore do
  import Ecto.Query, only: [from: 2]

  alias Backend.Repo
  alias Backend.Transaction

  def call(store) do
    query = from t in Transaction, where: t.store == ^store

    Repo.all(query)
  end
end
