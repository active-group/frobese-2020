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
    # pid = spawn(ProcessDemo, :echo, [])
    # __MODULE__ hier ProcessDemo
    pid = spawn(__MODULE__, :echo, [])
    Process.register(pid, :echo)
  end

  def inc_loop(n) do
    receive do
      i -> IO.puts(n)
           inc_loop(n + i)
    end
  end

  def start_inc_loop(n) do
    pid = spawn(__MODULE__, :inc_loop, [n])
    Process.register(pid, :inc)
  end

end
