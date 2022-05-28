defmodule Backend.Transactions.Repository.Create do
  alias Backend.Transaction
  alias Backend.Repo

  def call(params) do
    params
    |> Transaction.changeset()
    |> Repo.insert()
  end
end
