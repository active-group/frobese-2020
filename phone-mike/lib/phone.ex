defmodule Phone do
  use GenServer

  def start_link(ip, port, number) do
    GenServer.start_link(__MODULE__, {ip, port, number})
  end

  defmodule Dial do
    use QuickStruct, [number: term()]
  end

  def dial(phone_pid, number) do
    GenServer.cast(phone_pid, Dial.make(number))
  end

  @impl true
  def init({ip, port, number}) do
    # connect redet mit accept
    {:ok, socket} = :gen_tcp.connect(ip, port, [:binary,
                                                {:packet, :line},
                                                # jedes Paket wird als Nachricht verschickt:
                                                # {:tcp, socket, packet}
                                                {:active, true}])
    :ok = :gen_tcp.send(socket, inspect(number) <> "\n")
    {:ok, socket}
  end

  # handle_cast verarbeitet *nur* GenServer.cast-Nachrichten
  # handle_call dito nur GenServer.call

  @impl true
  def handle_cast(%Dial{number: number}, socket) do
    :ok = :gen_tcp.send(socket, inspect({:dial, number}) <> "\n")
    {:noreply, socket}
  end

  @impl true
  def handle_info({:tcp, _socket, line}, socket) do
    {:ok, term} = ParseTerm.parse(line)
    IO.puts("tcp: #{inspect(term)}")
    case term do
      :connected -> {:noreply, socket}
      :found -> {:noreply, socket}
      :not_found -> {:noreply, socket}
    end
  end

end
