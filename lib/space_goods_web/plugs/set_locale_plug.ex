defmodule SpaceGoodsWeb.Plugs.SetLocalePlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    # If the user is logged in, get their preferred language.
    # Otherwise, get the language from the browser's session.
    locale =
      case conn.assigns[:current_user] do
        # Default to English if not set
        nil -> get_session(conn, :locale) || "en"
        # Default to English if user has no preferred language set
        user -> user.preferred_language || "en"
      end

    # Set the locale for Gettext
    Gettext.put_locale(SpaceGoodsWeb.Gettext, locale)

    # Assign the locale to the connection so it's available for rendering, not sure about that?!?
    assign(conn, :locale, locale)
  end
end
