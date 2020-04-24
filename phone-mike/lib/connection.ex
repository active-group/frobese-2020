defmodule Connection do
  use GenServer

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket,
                        name: Exchange.phone_number_to_atom(number))
  end

  @impl true
  def init(socket) do
    # {:ok, ... state ...}
  end
end
