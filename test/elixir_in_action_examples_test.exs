defmodule ElixirInActionExamplesTest do
  use ExUnit.Case
  doctest ElixirInActionExamples

  test "greets the world" do
    assert ElixirInActionExamples.hello() == :world
  end
end
