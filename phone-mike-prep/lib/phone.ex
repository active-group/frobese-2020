defmodule Phone do
  use GenServer

  defmodule Dial do
    use QuickStruct, [number: term()]
  end

  def dial(pid, number) do
    GenServer.cast(pid, Dial.make(number))
  end

  defmodule Pickup do
    use QuickStruct, []
  end

  @spec pickup(atom | pid | {atom, any} | {:via, atom, any}) :: :ok
  def pickup(pid) do
    GenServer.cast(pid, Pickup.make())
  end

  defmodule SendMessage do
    use QuickStruct, [message: term()]
  end

  def send_message(pid, message) do
    GenServer.cast(pid, SendMessage.make(message))
  end

  defmodule Hangup do
    use QuickStruct, []
  end

  def hangup(pid) do
    GenServer.cast(pid, Hangup.make())
  end

  defmodule State do
    use QuickStruct, [socket: :inet.socket(),
                      phase: :idle | :ringing | :dialing | :connected]
  end

  def start_phone(ip, port, number) do
      GenServer.start_link(__MODULE__, {ip, port, number}, name: String.to_atom("Elixir.Phone" <> to_string(number)))
  end

  @impl true
  def init({ip, port, number}) do
    {:ok, socket} = :gen_tcp.connect(ip, port, [:binary, {:packet, :line}, {:active, true}])
    send_term(socket, number)
    {:ok, State.make(socket, :idle)}
  end

  @impl true
  def handle_cast(%Dial{number: number}, state) do
    # FIXME: blocking
    send_term(state.socket, {:dial, number})
    IO.puts("dialing ...")
    {:noreply, %{state | phase: :dialing} }
  end
  def handle_cast(%Pickup{}, state) do
    send_term(state.socket, :pick_up)
    IO.puts("picking up ...")
    {:noreply, state}
  end
  def handle_cast(%SendMessage{message: message}, state) do
    send_term(state.socket, {:send_message, message})
    IO.puts("sending message: #{inspect(message)}")
    {:noreply, state}
  end
  def handle_cast(%Hangup{}, state = %State{phase: :idle}) do
    {:noreply, state}
  end
  def handle_cast(%Hangup{}, state = %State{phase: :dialing}) do
    {:noreply, state}
  end
  def handle_cast(%Hangup{}, state = %State{phase: :ringing}) do
    {:noreply, state}
  end
  def handle_cast(%Hangup{}, state = %State{phase: :connected, socket: socket}) do
    send_term(socket, :hang_up)
    IO.puts("hanging up ...")
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, socket, line}, state) do
    {:ok, term} = Code.string_to_quoted(to_string(line))
    IO.puts("received: #{inspect(term)}")
    case handle_message(term, state) do
      {:no_response, new_state} ->
        {:noreply, new_state}
      {:response, response, new_state} ->
        send_term(socket, response)
        {:noreply, new_state}
    end
  end

  def handle_message(:connected, state) do
    {:no_response, %{state | phase: :connected}}
  end
  def handle_message(:no_such_number, state) do
    {:no_response, %{state | phase: :idle}}
  end
  def handle_message(:not_connected, state) do
    {:no_response, %{state | phase: :idle}}
  end
  def handle_message(:ok, state) do
    {:no_response, state} # questionable
  end
  def handle_message({:message, _message}, state) do
    {:no_response, state}
  end
  def handle_message({:called_from, _number}, state) do
    {:response, :connected, state}
  end
  def handle_message(:picked_up, state) do
    {:no_response, state}
  end
  def handle_message(:hung_up, state) do
    {:no_response, %{state | phase: :idle}}
  end


  def send_term(socket, term) do
    :ok = :gen_tcp.send(socket, String.to_charlist(inspect(term) <> "\n"))
  end

end
