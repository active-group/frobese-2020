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

  def positive?(n) do
    n > 0
  end

  @doc """
  Elemente aus einer Liste herausextrahieren

     iex> Intro.list_filter(&Intro.positive?/1, [1, -1, 2, 15, -13])
     [1, 2, 15]
     iex> Intro.list_filter(fn (n) -> n > 0 end, [1, -1, 2, 15, -13])
     [1, 2, 15]
  """
  @spec list_filter((a -> boolean()), list(a)):: list(a) when a: var
  def list_filter(_p?, []) do
    []
  end
  def list_filter(p?, [first | rest]) do
    # p?.(first) # . um Funktionen aufzurufen, die Wert eines Ausdrucks sind
    r = list_filter(p?, rest)
    if p?.(first) do
      [first | r]
    else
      r
    end
  end

  @doc """
     iex> Intro.list_map(&Animal.Dillo.run_over/1, [Animal.Dillo.d1, Animal.Dillo.d2])
     [Animal.Dillo.run_over(Animal.Dillo.d1), Animal.Dillo.d2]
  """

  @spec list_map((a -> b), list(a)) :: list(b) when a: var, b: var

  def list_map(_f, []) do
    []
  end
  def list_map(f, [first | rest]) do
    [f.(first) | list_map(f, rest)]
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


  def plus_one(n) do
    n + 1
  end

  # andere Funktion!
  def plus_one(n, x) do
    n + x + 1
  end

  def bar do
    list_map(&Intro.plus_one/1, [1, 2, 3])
    f = fn n -> n + 1 end
    &f.(5)
  end



end
