defmodule EventPlanningWeb.LoginController do
  use EventPlanningWeb, :controller

  plug EventPlanningWeb.Plugs.FakeAuth when action in [:success]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, %{"password" => value}) do
    conn = put_resp_cookie(conn, "password", value["password"])
    conn |> redirect(to: "/success")
  end

  def success(conn, _params) do
    conn |> put_flash(:info, "success") |> redirect(to: "/")
  end
end
