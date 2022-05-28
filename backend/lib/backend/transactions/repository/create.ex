defmodule Backend.Transactions.Repository.Create do
  alias Backend.Repo
  alias Backend.Transaction

  def call(params) do
    params
    |> Transaction.changeset()
    |> Repo.insert()
  end
end
