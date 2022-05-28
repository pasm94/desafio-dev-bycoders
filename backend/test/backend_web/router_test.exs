defmodule BackendWeb.RouterTest do
  use BackendWeb.ConnCase, async: true

  test "dashboard route", %{
    conn: conn
  } do
    response =
      conn
      |> get("/dashboard")
      |> html_response(302)

    assert "<html><body>You are being <a href=\"/dashboard/home\">redirected</a>.</body></html>" ==
             response
  end
end
