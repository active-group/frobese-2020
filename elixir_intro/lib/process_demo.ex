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

  defmodule Inc do
    use QuickStruct, [i: number()]
  end
  defmodule Get do
    use QuickStruct, [sender_pid: pid()]
  end

  def inc_loop(n) do
    receive do
      {:inc,  i} ->
        IO.puts(n)
        inc_loop(n + i)
      %Inc{i: i} ->
        IO.puts(n)
        inc_loop(n + i)
      {:get, sender_pid} ->
        send(sender_pid, n)
        inc_loop(n)
      %Get{sender_pid: sender_pid} ->
        send(sender_pid, n)
        inc_loop(n)
      msg ->
        IO.puts("unknown message: #{inspect(msg)}")
        inc_loop(n)
    end
  end

  def inc(pid, i) do
    # send(pid, {:inc, i})
    send(pid, Inc.make(i))
  end

  def inc(i) do
    inc(:inc, i)
  end

  def get(pid) do
    send(pid, {:get, self()})
    receive do
      msg -> msg
    end
  end

  def get() do
    get(:inc)
  end

  def start_inc_loop(n) do
    pid = spawn(__MODULE__, :inc_loop, [n])
    Process.register(pid, :inc)
  end

end
