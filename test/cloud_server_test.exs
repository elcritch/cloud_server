defmodule CloudServerTest do
  use ExUnit.Case
  doctest CloudServer

  test "greets the world" do
    assert CloudServer.hello() == :world
  end
end
