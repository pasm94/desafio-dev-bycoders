defmodule BackendWeb.TransactionController do
  use BackendWeb, :controller

  alias Backend.Transactions.Services.UploadCnabFile

  def upload_cnab_file(conn, %{"file" => %{path: file}}) do
    case UploadCnabFile.call(file) do
      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> render("upload.json", %{message: "This file could not be uploaded"})

      _ ->
        conn
        |> put_status(:created)
        |> render("upload.json", %{message: "File uploaded"})
    end
  end
end
