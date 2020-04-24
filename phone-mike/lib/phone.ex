defmodule Phone do
  use GenServer

  @impl true
  def init(_) do
    # connect redet mit accept
    {:ok, socket} = :gen_tcp.connect(ip, port, [:binary,
                                                {:packet, :line},
                                                {:active, true}])

  end
end
