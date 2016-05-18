defmodule Dashboard.Router do
  use Plug.Router

  require EEx
  EEx.function_from_file :def, :index, "priv/templates/index.html.eex", []

  plug Plug.Static, at: "/static", from: :dashboard

  plug :match
  plug :dispatch

  get "/events" do
    {:ok, events} = Riemann.query('service =~ "mesos %"')

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(events, pretty: true))
  end

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
