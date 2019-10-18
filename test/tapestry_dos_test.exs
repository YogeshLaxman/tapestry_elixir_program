defmodule TapestryDosTest do
  use ExUnit.Case
  doctest TapestryDos

  test "greets the world" do
    assert TapestryDos.hello() == :world
  end
end
