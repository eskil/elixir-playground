defmodule Http2serverWeb.ErrorJSONTest do
  use Http2serverWeb.ConnCase, async: true

  test "renders 404" do
    assert Http2serverWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Http2serverWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
