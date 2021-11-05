defmodule VideomeWeb.PageControllerTest do
  use VideomeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Videome !"
  end
end
