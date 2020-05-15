defmodule PhoneSup do
  def children(ip, port) do
    [
      %{
        id: Phone123,
        start: {Phone, :start_phone, [ip, port, 123]}
      },
      %{
        id: Phone456,
        start: {Phone, :start_phone, [ip, port, 456]}
      }
    ]
  end

  def start_phones(ip, port) do
    Supervisor.start_link(children(ip, port), strategy: :one_for_one)
  end
end
