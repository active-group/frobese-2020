defmodule Exchange do
  use GenServer

  defmodule NewPhoneServer do
    use QuickStruct, [number: term(), pid: pid()]
  end
  defmodule LookupPhone do
    use QuickStruct, [number: term()]
  end

  def new_phone_server(exchange_pid, number, pid) do
    GenServer.cast(exchange_pid, NewPhoneServer.make(number, pid))
  end

  @spec lookup_phone(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def lookup_phone(exchange_pid, number) do
    IO.puts("lookup_phone #{inspect(exchange_pid)} #{inspect(number)}")
    GenServer.call(exchange_pid, LookupPhone.make(number))
  end

  def start_exchange(ip, port) do
    GenServer.start_link(__MODULE__, [ip, port], [debug: [:trace]])
  end

  def accept_loop(listen_socket, exchange_pid) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    # FIXME: supervisor
    {:ok, _connection_pid} = PhoneConnection.start_link(exchange_pid, socket)
    accept_loop(listen_socket, exchange_pid)
  end

  @impl true
  def init([ip, port]) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, {:packet, :line}, {:active, false}, {:ip, ip}])
    # FIXME: supervisor
    exchange_pid = self()
    spawn_link(fn -> accept_loop(listen_socket, exchange_pid) end)
    {:ok, %{}}
  end

  @impl true
  def handle_cast(%NewPhoneServer{number: number, pid: pid}, phone_servers) do
    {:noreply, Map.put(phone_servers, number, pid)}
  end

  @impl true
  def handle_call(%LookupPhone{number: number}, _from_pid, phone_servers) do
    {:reply,
     Map.fetch(phone_servers, number),
     phone_servers}
  end

end
