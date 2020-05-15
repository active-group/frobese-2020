defmodule PhoneConnection do
  use GenServer

  defmodule State do
    use QuickStruct, [exchange_pid: pid(), number: term(), socket: :inet.socket(),
                      connection: pid() | nil]
  end

  defmodule ForwardMessage do
    use QuickStruct, [message: String.t]
  end

  defmodule Pickup do
    use QuickStruct, []
  end

  defmodule Hangup do
    use QuickStruct, []
  end

  defmodule Call do
    use QuickStruct, [from_number: term(), pid: pid()]
  end

  def start_link(exchange_pid, socket) do
    IO.puts("starting phone connection")
    {:ok, number_charlist} = :gen_tcp.recv(socket, 0)
    IO.puts("number: #{inspect(number_charlist)}")
    send_term(socket, :connected)
    {:ok, number} = Code.string_to_quoted(to_string(number_charlist))
    GenServer.start_link(__MODULE__, State.make(exchange_pid, number, socket, nil),
                         [debug: [:trace]])
  end

  @impl true
  def init(state) do
    connection_pid = self()
    spawn_link(fn -> feed_messages_to_genserver(state.socket, connection_pid) end)
    Exchange.new_phone_server(state.exchange_pid, state.number, connection_pid)
    {:ok, state}
  end

  def feed_messages_to_genserver(socket, pid) do
    {:ok, message} = :gen_tcp.recv(socket, 0)
    IO.puts("message: #{inspect(message)}")
    send(pid, {:tcp, socket, message})
    feed_messages_to_genserver(socket, pid)
  end


  @impl true
  def handle_info({:tcp, socket, line}, state) do
    IO.puts("line: #{inspect(line)}")
    {:ok, term} = Code.string_to_quoted(to_string(line))
    {:ok, response, new_state} = handle_request(term, state)
    send_term(socket, response)
    {:noreply, new_state}
  end

  def send_term(socket, term) do
    :ok = :gen_tcp.send(socket, String.to_charlist(inspect(term) <> "\n"))
  end

  @impl true
  def handle_cast(%ForwardMessage{message: message}, state) do
    send_term(state.socket, {:message, message})
    {:noreply, state}
  end
  def handle_cast(%Call{from_number: from_number, pid: pid}, state) do
    send_term(state.socket, {:called_from, from_number})
    {:noreply, %{state | connection: pid}}
  end
  def handle_cast(%Hangup{}, state) do
    send_term(state.socket, :hung_up)
    {:noreply, %{state | connection: nil}}
  end
  def handle_cast(%Pickup{}, state) do
    send_term(state.socket, :picked_up)
    {:noreply, state}
  end

  def handle_request({:dial, number}, state) do
    case Exchange.lookup_phone(state.exchange_pid, number) do
      {:ok, pid} ->
        GenServer.cast(pid, Call.make(state.number, self()))
        {:ok, :connected, %{state | connection: pid}}
      _ -> {:ok, :no_such_number, state}
    end
  end

  def handle_request({:send_message, message}, state) do
    case state.connection do
      nil -> {:ok, :not_connected, state}
      pid ->
        GenServer.cast(pid, ForwardMessage.make(message))
        {:ok, :ok, state}
    end
  end

  def handle_request(:pick_up, state) do
    case state.connection do
      nil -> {:ok, :not_connected, state}
      pid ->
        GenServer.cast(pid, Pickup.make())
        {:ok, :connected, state}
    end
  end

  def handle_request(:hang_up, state) do
    case state.connection do
      nil -> {:ok, :not_connected, state}
      pid ->
        GenServer.cast(pid, Hangup.make())
        {:ok, :ok, state}
    end
  end

  def handle_request(:connected, state) do
    case state.connection do
      nil -> {:ok, :not_connected, state} # can this happen?
      _pid ->
        {:ok, :ok, state}
    end
  end

end
