defmodule Animal do
  defmodule Dillo do
    # 1 Typ zusammengesetzter Daten <-> 1 Modul
    @enforce_keys [:alive?, :weight]
    defstruct [:alive?, :weight]
    @type t :: %Dillo{alive?: boolean(), weight: number()}
    @spec make(boolean(), number()) :: Dillo.t()
    def make(alive?, weight) do
      %Dillo{alive?: alive?, weight: weight}
    end
  end
end
