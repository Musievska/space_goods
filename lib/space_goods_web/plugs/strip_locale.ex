defmodule SpaceGoodsWeb.Plugs.StripLocale do
  @behaviour Plug

  # List your locales here
  @locales ~w(en bg)

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.request_path do
      "/" <> rest ->
        locale = hd(String.split(rest, "/"))

        if locale in @locales do
          Plug.Conn.put_private(conn, :phoenix_route, rest)
        else
          conn
        end

      _ ->
        conn
    end
  end
end
