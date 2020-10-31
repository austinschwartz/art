defmodule ArtWeb.PageController do
  use ArtWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
