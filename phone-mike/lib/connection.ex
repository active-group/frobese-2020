defmodule Connection do
  use GenServer

  def start_link(socket, exchange_pid) do
    # Socket hat {:packet, :line}
    # und liefert darum eine Textzeile
    {:ok, line} = :gen_tcp.recv(socket, 0)
    IO.puts("line: #{inspect(line)}")
    :ok = :gen_tcp.send(socket, ":connected\n")
    # anderer Prozeß als der GenServer
    IO.puts("number: #{inspect(Exchange.phone_number_to_atom(ParseTerm.parse(line)))}")
    {:ok, number} = ParseTerm.parse(line)
    GenServer.start_link(__MODULE__, {socket, exchange_pid},
                        name: Exchange.phone_number_to_atom(number))
  end

  # Telefonanruf:
  # 1. Telefon redet mit Connection: dial 123
  # 2. Connection redet mit Exchange, um die Pid der Connection von 123 herauszubekommen
  #    (lookup_phone_number)
  # 3. Connection-Prozesse können sich ab da Nachrichten direkt schicken

  def feed_message_from_socket_to_genserver(socket, pid) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    {:ok, term} = ParseTerm.parse(line)
    GenServer.cast(pid, term)
    feed_message_from_socket_to_genserver(socket, pid)
  end

  defmodule State do
    use QuickStruct, [socket: :inet.socket(), exchange_pid: pid()]
  end


  @impl true
  def init({socket, exchange_pid}) do
    # läuft im Prozeß des GenServers
    connection_pid = self() # WICHTIG!!!!!!
    spawn_link(fn -> feed_message_from_socket_to_genserver(socket, connection_pid) end)
    {:ok, State.make(socket, exchange_pid)}
  end

  # Andere Nummer wählen
  # {:dial, <number>}

  @impl true
  def handle_cast({:dial, number}, state) do
    result = Exchange.lookup_phone(state.exchange_pid, number)
    IO.puts(inspect(result))
    {:noreply, state}
  end


end
