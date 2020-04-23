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

  test "water_state operates correctly" do
    assert Intro.water_state(-10) == Solid
  end
end
