defmodule Phone do
  use GenServer

  @impl true
  def init({port, ip, number}) do
    # connect redet mit accept
    {:ok, socket} = :gen_tcp.connect(ip, port, [:binary,
                                                {:packet, :line},
                                                {:active, true}])
    :gen_tcp.send(socket, inspect(number) <> "\n")

  end
end
