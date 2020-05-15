defmodule PhoneConnectionSup do
  def start_link() do
    Supervisor.start_link([{DynamicSupervisor, strategy: :one_for_one,
			    name: __MODULE__}],
                          strategy: :one_for_one)
  end

  def start_exchange(exchange_pid, socket) do
    DynamicSupervisor.start_child(__MODULE__,
      %{id: PhoneConnection,
        start: {PhoneConnection, :start_link, [exchange_pid, socket]}})
  end
end
