defmodule EventPlanningWeb.Plugs.FakeAuth do
  import Plug.Conn
  use EventPlanningWeb, :controller

  def init(default), do: default

  def call(conn, default) do
    password = checkDefault(conn, default)
    # IO.inspect("")
    # IO.inspect(password)
    # IO.inspect("")

    case password do
      "password" -> assign(conn, :auth, true)
      _ -> conn |> put_flash(:info, "You must be logged in") |> redirect(to: "/login") |> halt()
    end
  end

  defp checkDefault(conn, default) do
    case default do
      [] -> getPassCookie(conn)
      _ -> default
    end
  end

  defp getPassCookie(conn) do
    fetch_cookies(conn, signed: ~w(password))
    |> Map.from_struct()
    |> get_in([:req_cookies, "password"])
  end
end
