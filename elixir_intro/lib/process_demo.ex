defmodule ProcessDemo do
  # while (true) { ... }
  # for (;;) { ... }
  def echo() do
    receive do
      msg -> IO.puts(msg)
    end
    echo() # endrekursiver Aufruf
  end

  def start_echo() do
    spawn(&echo/0)
  end
end
