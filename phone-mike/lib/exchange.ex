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

  def start_link(ip, port) do
    GenServer.start_link(__MODULE__,
                         {ip, port})
  end

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
  def init({ip, port}) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, # im Gegensatz zu :list
                            # {:packet, 0}, # "natürliche" TCP/IP-Packets
                            {:packet, :line}, # einzelne Textzeile
                            {:active, false}, # {:active, true} bedeutet, daß die Pakete automatisch
                                              # an Server geschickt
                            {:ip, ip}
                            ])

    exchange_pid = self() # NICHT INS SPAWN_LINK!
    spawn_link(fn -> accept_loop(listen_socket, exchange_pid) end)
    {:ok, nil}
  end

  def accept_loop(listen_socket, exchange_pid) do
    # blockiert, bis ein Klient vorbeikommt, macht dann einen neuen Socket
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    # mach irgendwas mit dem Socket
    start_connection(socket, exchange_pid)
    accept_loop(listen_socket, exchange_pid)
  end

  def start_connection(socket, exchange_pid) do
    # FIXME: Eine sterbende Connection zieht den ganzen Laden runter
    spawn(fn -> Connection.start_link(socket, exchange_pid) end)
  end

  # Exchange hat zwei Aufgaben:
  # - neue Verbindungen entgegennehmen
  # - für eine Telefonnummer den Connection-Prozeß finden
  defmodule LookupPhone do
    use QuickStruct, [number: term()]
  end

  @spec phone_number_to_atom(term()) :: atom()
  def phone_number_to_atom(term) do
    String.to_atom(inspect(term))
  end

  @impl true
  def handle_call(%LookupPhone{number: number}, _from, _) do
    case GenServer.whereis(phone_number_to_atom(number)) do
      nil -> {:reply,
              :not_found,
              nil}
      pid -> {:reply, {:ok, pid}, nil}
    end
  end

  @spec lookup_phone(pid(), term()):: :not_found | {:ok, pid()}
  def lookup_phone(exchange_pid, number) do
    GenServer.call(exchange_pid, LookupPhone.make(number))
  end

end
