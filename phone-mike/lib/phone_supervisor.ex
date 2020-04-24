defmodule PhoneSupervisor do
  def children(ip, port) do
    [
      # Liste von Spezifikationen, wie Prozesse gestartet werden
      %{
        id: Phone123, # Pflicht
        start: {Phone, :start_link, [ip, port, 123]}
      },
      %{
        id: Phone456,
        start: {Phone, :start_link, [ip, port, 456]}
      }
    ]
  end

  def start_link(ip, port) do
    Supervisor.start_link(children(ip, port),
                          strategy: :one_for_one)
    # :one_for_all
    # :rest_for_one
  end
end
