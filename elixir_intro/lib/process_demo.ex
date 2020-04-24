defmodule ProcessDemo do
  # while (true) { ... }
  # for (;;) { ... }
  def echo() do
    receive do
      :terminate -> nil
      msg ->
        IO.puts(msg)
        echo() # endrekursiver Aufruf
    end
  end

  def start_echo() do
    spawn(&echo/0)
  end
end
