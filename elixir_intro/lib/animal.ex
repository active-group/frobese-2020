defmodule Animal do
  defmodule Dillo do
    # 1 Typ zusammengesetzter Daten <-> 1 Modul
    # @enforce_keys [:alive?, :weight]
    # defstruct [:alive?, :weight]
    # @type t :: %Dillo{alive?: boolean(), weight: number()}
    # @spec make(boolean(), number()) :: Dillo.t()
    # def make(alive?, weight) do
    #   %Dillo{alive?: alive?, weight: weight}
    # end
    use QuickStruct, [alive?: boolean(), weight: number()]

    def d1 do # Gürteltier, am Leben, 10kg
      Animal.Dillo.make(true, 10)
    end
    def d2, do: Dillo.make(false, 12) # tot, 12kg

    @doc """
    Gürteltier überfahren

      iex> Animal.Dillo.run_over(Animal.Dillo.d1)
      %Animal.Dillo{alive?: false, weight: 10}
      iex> Animal.Dillo.run_over(Animal.Dillo.d2)
      Animal.Dillo.d2
    """

    @spec run_over(Animal.Dillo.t()) :: Animal.Dillo.t()
    # def run_over(dillo) do
    #   Dillo.make(false, dillo.weight)
    # end
    # def run_over(%Dillo{alive?: _a, weight: w}) do
    #   Dillo.make(false, w)
    # end
    def run_over(dillo) do
      %{dillo | alive?: false} # Kopie von dillo, nur ist alive? dann false
    end
  end

  defmodule Parrot do
    use QuickStruct, [sentence: String.t(), weight: number()]

    def p1, do: Parrot.make("Hello!", 2)
    def p2, do: Parrot.make("Goodbye!", 3)

    @doc """
    Papagei überfahren

      iex> Animal.Parrot.run_over(Animal.Parrot.p1)
      %Animal.Parrot{sentence: "", weight: 2}
      iex> Animal.Parrot.run_over(Animal.Parrot.p2)
      Animal.Parrot.make("", 2)
    """
    @spec run_over(Parrot.t()) :: Parrot.t()
    def run_over(parrot) do
      nil
    end


  end
end
