defmodule Backend.Transactions.Services.UploadCnabFile do
  alias Backend.Transactions.Repository.Create

  def call(file) do
    file
    |> File.read()
    |> parse_data()
    |> insert_transactions()
  end

  defp parse_data({:ok, transactions}) do
    transactions
    |> String.trim()
    |> split_text_by_line()
    |> build_transactions_list()
  end

  defp parse_data({:error, reason}), do: {:error, reason}

  defp split_text_by_line(txt), do: String.split(txt, "\n")

  defp build_transactions_list(transactions) do
    Enum.map(transactions, &build_transaction_map(&1))
  end

  defp insert_transactions({:error, reason}), do: {:error, reason}

  defp insert_transactions(transactions) do
    Enum.map(transactions, fn transaction ->
      if is_map(transaction), do: Create.call(transaction)
    end)
  end

  defp build_transaction_map(transaction) do
    %{
      type: String.slice(transaction, 0, 1),
      date: build_date(transaction),
      value: String.slice(transaction, 9, 10),
      cpf: String.slice(transaction, 19, 11),
      card: String.slice(transaction, 30, 12),
      hour: build_time(transaction),
      store_owner: build_string(transaction, 48, 14),
      store: build_string(transaction, 62, 19)
    }
  end

  defp build_string(transaction, start, length) do
    transaction
    |> String.slice(start, length)
    |> String.trim()
  end

  defp build_date(transaction) do
    yyyy = String.slice(transaction, 1, 4)
    mm = String.slice(transaction, 5, 2)
    dd = String.slice(transaction, 7, 2)

    {:ok, date} = Date.from_iso8601("#{yyyy}-#{mm}-#{dd}")

    date
  end

  defp build_time(transaction) do
    hh = String.slice(transaction, 42, 2)
    mm = String.slice(transaction, 44, 2)
    ss = String.slice(transaction, 46, 2)

    {:ok, time} = Time.from_iso8601("#{hh}:#{mm}:#{ss}")

    time
  end
end
