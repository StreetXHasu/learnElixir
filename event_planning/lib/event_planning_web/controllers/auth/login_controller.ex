defmodule EventPlanningWeb.LoginController do
  use EventPlanningWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, %{"password" => value}) do
    conn = put_resp_cookie(conn, "password", value["password"])
    IO.inspect(value["password"])
    render(conn, "index.html")
  end
end
