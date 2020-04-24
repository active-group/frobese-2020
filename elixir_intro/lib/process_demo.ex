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

  # Messages, die inc_loop akzeptiert:

  # um Wert inkrementieren
  defmodule Inc do
    use QuickStruct, [i: number()]
  end
  # Wert abholen
  defmodule Get do
    use QuickStruct, [sender_pid: pid()]
  end

  # Server
  def inc_loop(n) do
    receive do
      # alt:
      {:inc,  i} ->
        IO.puts(n)
        inc_loop(n + i)
      # neu:
      %Inc{i: i} ->
        IO.puts(n)
        inc_loop(n + i)
      # alt:
      {:get, sender_pid} ->
        send(sender_pid, n)
        inc_loop(n)
      # neu:
      %Get{sender_pid: sender_pid} ->
        send(sender_pid, n)
        inc_loop(n)
      msg ->
        IO.puts("unknown message: #{inspect(msg)}")
        inc_loop(n)
    end
  end

  def start_inc_loop(n) do
    pid = spawn(__MODULE__, :inc_loop, [n])
    Process.register(pid, :inc)
  end

  # Client
  def inc(pid, i) do
    # send(pid, {:inc, i})
    send(pid, Inc.make(i))
  end

  def inc(i) do
    inc(:inc, i)
  end

  def get(pid) do
    # send(pid, {:get, self()})
    send(pid, Get.make(self()))
    receive do
      msg -> msg
    end
  end

  def get() do
    get(:inc)
  end

  def order(pid) do
    # :message1 kommt auf jeden Fall vor :message3 an
    # möglicherweise kommt :message1 auch vor :message2 an
    send(pid, :message1)
    spawn(fn -> send(pid, :message2) end)
    send(pid, :message3)
  end

  def die_process() do
    receive do
      msg -> IO.puts(10 / msg)
             die_process()
    end
  end

  def start_die_process() do
    pid = spawn(&die_process/0)
    # theoretisch kann der Prozeß hier schon gestorben
    Process.link(pid) # wenn der eine stirbt, stirbt auch der andere
    # theoretisch kann der Prozeß genau hier sterben
    # Wenn andere verlinkte Prozesse sterben, sterbe nicht ich,
    # bekomme aber eine Nachricht {:EXIT, ...}
    Process.flag(:trap_exit, true)

    # deshalb:
    # spawn_link macht spawn + link atomar
    # spawn_monitor macht spawn + link + trap_exit atomar
    # spawn_monitor
    # Process.demonitor
  end
end
