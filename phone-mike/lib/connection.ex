defmodule Connection do
  use GenServer

  def start_link(socket) do
    # Socket hat {:packet, :line}
    # und liefert darum eine Textzeile
    {:ok, line} = :gen_tcp.recv(socket, 0)

    GenServer.start_link(__MODULE__, socket,
                        name: Exchange.phone_number_to_atom(number))
  end

  @impl true
  def init(socket) do
    # {:ok, ... state ...}
  end
end
