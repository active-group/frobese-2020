defmodule Connection do
  use GenServer

  def start_link(socket) do
    # Socket hat {:packet, :line}
    # und liefert darum eine Textzeile
    {:ok, line} = :gen_tcp.recv(socket, 0)
    IO.puts("line: #{inspect(line)}")
    :ok = :gen_tcp.send(socket, ":connected")
    GenServer.start_link(__MODULE__, socket,
                        name: Exchange.phone_number_to_atom(line))
  end

  # Telefonanruf:
  # 1. Telefon redet mit Connection: dial 123
  # 2. Connection redet mit Exchange, um die Pid der Connection von 123 herauszubekommen
  #    (lookup_phone_number)
  # 3. Connection-Prozesse können sich ab da Nachrichten direkt schicken

  def feed_message_from_socket_to_genserver(socket, pid) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    GenServer.cast(pid, line)
    feed_message_from_socket_to_genserver(socket, pid)
  end

  @impl true
  def init(_socket) do
    {:ok, nil}
  end
end
