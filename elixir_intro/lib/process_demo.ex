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
    # pid = spawn(&echo/0)
    pid = spawn(ProcessDemo, :echo, [])
    Process.register(pid, :echo)
  end
end
