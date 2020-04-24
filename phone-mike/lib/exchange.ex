defmodule Exchange do
  use GenServer

  # Jedes Telefon hat eine Nummer
  # => jede Connection hat eine Nummer
  # Wollen Nachrichten austauschen zwischen den
  # Connections => brauchen für jede Connection
  # die Pid
  # => benutzen dafür Process.register

  # Jemand kauft ein Telefon, schließt es an,
  # es nimmt Verbindung auf zum Exchange, der
  # daraufhin einen Connection-Prozeß hochfährt.

  # Blog-Post:
  # init()
  #
  # def init [ip,port] do
  #   {:ok,listen_socket} = :gen_tcp.listen(port,[:binary,{:packet, 0},{:active,true},{:ip,ip}])
  #   {:ok,socket } = :gen_tcp.accept listen_socket
  #   {:ok, %{ip: ip, port: port, socket: socket}}
  # end

  # wie @override in Java
  @impl true
  def ini({ip, port}) do
  end


end
