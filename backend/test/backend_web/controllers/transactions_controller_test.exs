defmodule BackendWeb.TransactionsControllerTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Repo
  alias Backend.Transaction

  describe "get_by_store/2" do
    test "if store doesnt exist, should return an empty list", %{conn: conn} do
      response =
        conn
        |> get(Routes.transaction_path(conn, :get_by_store, "invalid store"))
        |> json_response(200)

      assert %{"data" => []} == response
    end

    test "if store exist, should return transactions and balance", %{
      conn: conn
    } do
      {:ok, date_1} = Date.new(2019, 03, 01)
      {:ok, date_2} = Date.new(2019, 06, 21)

      {:ok, time_1} = Time.new(23, 30, 00)
      {:ok, time_2} = Time.new(14, 10, 08)

      transaction_1 = %Transaction{
        type: 1,
        date: date_1,
        value: 1_520_000,
        cpf: "09620676017",
        card: "1234****7890",
        hour: time_1,
        store_owner: "JOÃO MACEDO",
        store: "BAR DO JOÃO"
      }

      transaction_2 = %Transaction{
        type: 2,
        date: date_2,
        value: 1_132_000,
        cpf: "09620676017",
        card: "1234****7890",
        hour: time_2,
        store_owner: "JOÃO MACEDO",
        store: "BAR DO JOÃO"
      }

      Repo.insert!(transaction_1)
      Repo.insert!(transaction_2)

      response =
        conn
        |> get(Routes.transaction_path(conn, :get_by_store, "BAR DO JOÃO"))
        |> json_response(200)

      assert %{
               "data" => %{
                 "amount" => "R$3,880.00",
                 "transactions" => [
                   %{
                     "card" => "1234****7890",
                     "cpf" => "09620676017",
                     "date" => "2019-03-01",
                     "hour" => "23:30:00",
                     "id" => _,
                     "store" => "BAR DO JOÃO",
                     "store_owner" => "JOÃO MACEDO",
                     "type" => 1,
                     "value" => "R$15,200.00"
                   },
                   %{
                     "card" => "1234****7890",
                     "cpf" => "09620676017",
                     "date" => "2019-06-21",
                     "hour" => "14:10:08",
                     "id" => _,
                     "store" => "BAR DO JOÃO",
                     "store_owner" => "JOÃO MACEDO",
                     "type" => 2,
                     "value" => "R$11,320.00"
                   }
                 ]
               }
             } = response
    end
  end

  describe "upload_cnab_file/2" do
    test "if file is valid, should upload the file and return a confirmation message", %{
      conn: conn
    } do
      upload = %Plug.Upload{
        content_type: "text/plain",
        path: "test/fixtures/CNAB.txt",
        filename: "CNAB.txt"
      }

      response =
        conn
        |> post("/api/transaction", %{:file => upload})
        |> json_response(201)

      all = Repo.all(Transaction)

      assert length(all) == 4

      assert %{"message" => "File uploaded"} == response
    end

    test "if file is invalid, should return an error message", %{
      conn: conn
    } do
      upload = %Plug.Upload{
        content_type: "text/plain",
        path: "test/fixtures/invalid_path.txt",
        filename: "CNAB.txt"
      }

      response =
        conn
        |> post("/api/transaction", %{:file => upload})
        |> json_response(400)

      assert %{"message" => "This file could not be uploaded"} == response
    end
  end
end
