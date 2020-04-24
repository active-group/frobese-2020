defmodule IncServer do
  use GenServer # wir implementieren ein Interface
  # GenServer gehört zu OTP: Open Telephony Platform

  def start(n) do
    # 1. startet einen neuen Prozeß
    # 2. ruft in diesem Prozeß IncServer.init/1 auf, übergibt dabei n,
    #    bekommt es den initialen Zustand
    # 3. startet dann eine endrekursive Schleife, die Nachrichten akzeptiert,
    #    beantwortet und den Zustand verwaltet
    GenServer.start(__MODULE__, n)
  end

  def init(n) do
    {:ok, n} # n: initiale Zustand
  end
end
