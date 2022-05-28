defmodule Backend.Transactions.Services.GetByStore do
  alias Backend.Transactions.Repository.GetByStore

  @subtraction [2, 3, 9]

  def call(store) do
    store
    |> GetByStore.call()
    |> handle_response()
  end

  defp handle_response([]), do: []

  defp handle_response(transactions) do
    amount =
      Enum.reduce(transactions, Money.new(0), fn %{type: type, value: value}, acc ->
        case Enum.member?(@subtraction, type) do
          true -> Money.subtract(acc, value)
          _ -> Money.add(acc, value)
        end
      end)

    %{
      amount: Money.to_string(amount),
      transactions: update_money_values_to_string(transactions)
    }
  end

  defp update_money_values_to_string(transactions) do
    Enum.map(transactions, fn t -> %{t | value: Money.to_string(t.value)} end)
  end
end
