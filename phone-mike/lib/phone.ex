defmodule Phone do
  use GenServer

  @impl true
  def init({port, ip, number}) do
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
  def handle_info({:tcp, socket, line}, _socket) do

  end

end
