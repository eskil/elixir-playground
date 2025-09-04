defmodule Http2serverWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use Http2serverWeb, :html

  embed_templates "page_html/*"
end
