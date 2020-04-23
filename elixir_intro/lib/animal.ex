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
      Dillo.make(true, 10)
    end
  end
end
