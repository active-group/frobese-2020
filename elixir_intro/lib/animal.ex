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
      d2
    """

    @spec run_over(Animal.Dillo.t()) :: Animal.Dillo.t()
    # def run_over(dillo) do
    #   Dillo.make(false, dillo.weight)
    # end
    # def run_over(%Dillo{alive?: _a, weight: w}) do
    #   Dillo.make(false, w)
    # end
    def run_over(dillo) do
      %{dillo | alive?: false} # Kopie von dillo, nur ist alive? dann false
    end

  end
end
