defmodule Intro do

  # Namen mit Großbuchstaben: Atom
  # Namen mit Kleinbuchstaben: Variablen
  # Erlang: genau umgekehrt
  # :atom : Atom mit Namen atom

  @moduledoc """
  Documentation for `Intro`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Intro.hello()
      :world

  """
  def hello() do
    :world
  end

  # | : "oder"
  # Atom: "genau das Atom"
  @type pet :: Cat | Dog | TasmanianDevil

  @doc """
  Ist ein Haustier niedlich?

    iex> Intro.cute?(Cat)
    true
    iex> Intro.cute?(Dog)
    true
    iex> Intro.cute?(TasmanianDevil)
    false
  """
  # @spec cute?(Cat | Dog | TasmanianDevil):: boolean
  @spec cute?(pet):: boolean
#  def cute?(pet) do
#    cond do
#      pet == Cat -> true
#      pet == Dog -> true
#      pet == TasmanianDevil -> false
#    end
#  end
  def cute?(5) do
    false
  end
  def cute?(Cat) do # Pattern
    true
  end
  def cute?(Dog) do
    true
  end
  def cute?(TasmanianDevil) do
    false
  end

  @doc """
  Aggregatzustand von Wasser berechnen

     iex> Intro.water_state(10)
     Liquid
     iex> Intro.water_state(-1)
     Solid
     iex> Intro.water_state(100)
     Gas
  """



end
