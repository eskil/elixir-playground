defmodule A3 do
  @runtime_dependency_on_b B3
  def foo, do: :foo

  def foobar() do
    # Silence "unused attribute" warnings
    IO.puts(@runtime_dependency_on_b)
  end
end
