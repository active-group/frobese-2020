defmodule ProcessDemo do
  # while (true) { ... }
  # for (;;) { ... }
  def echo() do
    receive do
      msg -> IO.puts(msg)
    end
    echo() # endrekursiver Aufruf
  end
end
