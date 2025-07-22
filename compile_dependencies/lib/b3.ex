defmodule B3 do
  @runtime_dependency_on_c C3

  def foo() do
    # Silence "unused attribute" warnings
    IO.puts(@runtime_dependency_on_c)
  end
end
