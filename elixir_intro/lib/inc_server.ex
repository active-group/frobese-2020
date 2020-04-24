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
    {:ok, n} # n: initialer Zustand
  end

  # GenServer unterscheidet zwischen "fire-or-forget"-Nachrichten: "cast"
  # NICHT WIE JAVA-CAST!
  # wie Inc
  # und Nachrichten, die eine Antwort erwarten: "call"
  # wie Get

  # Messages, die inc_loop akzeptiert:

  # um Wert inkrementieren
  defmodule Inc do
    use QuickStruct, [i: number()]
  end
  # Wert abholen
  defmodule Get do
    use QuickStruct, []
  end

  def handle_cast(%Inc{i: i}, n) do
    IO.puts("current state: #{n}")
    {:noreply, n + i}
  end

  def handle_call(%Get{}, _from, n) do
    # Doku:  {:reply, reply, new_state}
    {:reply,
     n, # Antwort, GenServer schickt die automatisch zurück
     n} # neue Zustand
  end
end
