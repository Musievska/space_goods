defmodule SpaceGoodsWeb.Gettext do
  # def supported_locales do
  # ["en", "rus", "bg", ...] # and so on
  # end

  # mix gettext.extract
  # mix gettext.merge priv/gettext
  # mix gettext.merge priv/gettext --locale=bg

  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import SpaceGoodsWeb.Gettext

      # Simple translation
      gettext("Here is the string to translate")

      # Plural translation
      ngettext("Here is the string to translate",
               "Here are the strings to translate",
               3)

      # Domain-based translation
      dgettext("errors", "Here is the error message to translate")

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext, otp_app: :space_goods
end
