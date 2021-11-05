defmodule VideomeWeb.PageController do
  use VideomeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
