defmodule ClientOne do
  @compile_time_dependency_on_a A3.foo()

  def foo() do
    # Silence "unused attribute" warnings
    IO.puts(@compile_time_dependency_on_a)
  end
end
