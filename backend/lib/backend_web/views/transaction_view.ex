defmodule BackendWeb.TransactionView do
  use BackendWeb, :view

  def render("upload.json", %{message: message}), do: %{message: message}
end
