defmodule IntroTest do
  use ExUnit.Case
  doctest Intro

  test "greets the world" do
    assert Intro.hello() == :world
  end

  test "cute animals are correctly identified" do
    assert Intro.cute?(Dog) == true
    assert Intro.cute?(Cat)
    assert Intro.cute?(TasmanianDevil) == false
  end
end
