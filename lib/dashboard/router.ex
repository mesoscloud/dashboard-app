defmodule Dashboard.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    {:ok, events} = Riemann.query('true')

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Poison.encode!(events, pretty: true))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
