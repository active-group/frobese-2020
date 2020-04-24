defmodule Connection do
  use GenServer

  def start_link(socket) do
    # Socket hat {:packet, :line}
    # und liefert darum eine Textzeile
    {:ok, line} = :gen_tcp.recv(socket, 0)
    IO.puts("line: #{inspect(line)}")
    GenServer.start_link(__MODULE__, socket,
                        name: Exchange.phone_number_to_atom(line))
  end

  @impl true
  def init(_socket) do
    {:ok, nil}
  end
end
