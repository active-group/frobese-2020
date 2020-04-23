defmodule Animal do
  defmodule Dillo do
    # 1 Typ zusammengesetzter Daten <-> 1 Modul
    @enforce_keys [:alive?, :weight]
    defstruct [:alive?, :weight]
  end
end
