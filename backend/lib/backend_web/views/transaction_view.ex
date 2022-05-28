defmodule BackendWeb.TransactionView do
  use BackendWeb, :view

  def render("get_by_store.json", %{data: data}), do: %{data: data}

  def render("upload.json", %{message: message}), do: %{message: message}
end
