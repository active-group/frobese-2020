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
  @type state :: Liquid | Solid | Gas
  @spec water_state(number()) :: state()
  def water_state(temp) do
    cond do
      temp < 0 -> Solid
      temp >= 0 && temp < 100 -> Liquid
      temp >= 100 -> Gas
    end
  end

  def foo() do
    water_state(-100.5)
  end

  @doc """
  Elemente einer Liste summieren

    iex> Intro.list_sum([1, 2, 3])
    6
  """
  @spec list_sum(list(number())) :: number()
  def list_sum([]) do
    0
  end
  def list_sum([first | rest]) do
    first + list_sum(rest)
  end

  @doc """
  Elemente aus einer Liste herausextrahieren
  """
  @spec list_filter((a -> b), list(a)):: list(b), var: a, var: b
  def list_filter(p?, []) do

  end
  def list_filter(p?, [first | rest]) do

  end

  # String.t() für Strings
  # boolean()  # Erlang
  # integer()  # Erlang
  # in Erlang sind Strings Listen aus Unicode-Scalar-Values
  # string() gibt's deshalb nicht
  # String.t() ist UTF-8
  # Erlang-Strings heißen in Elixir "charlist"
  # Elixir-Strings heißen in Erlang "binary"
  # Hin- und Her-Konvertieren mit String.to_charlist, to_string


end
