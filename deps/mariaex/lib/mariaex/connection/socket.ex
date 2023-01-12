defmodule Mariaex.Connection.Socket do
  def connect(filename, _port, socket_options, timeout) do
    Mariaex.Connection.Tcp.connect({:local, filename}, 0, socket_options, timeout)
  end

  def recv(sock, bytes, timeout), do: :gen_tcp.recv(sock, bytes, timeout)

  def recv_active(sock, timeout, buffer \\ :active_once) do
    receive do
      {:tcp, ^sock, buffer} ->
        {:ok, buffer}
      {:tcp_closed, ^sock} ->
        {:disconnect, {tag(), "async_recv", :closed, buffer}}
      {:tcp_error, ^sock, reason} ->
        {:disconnect, {tag(), "async_recv", reason, buffer}}
    after
      timeout ->
        {:ok, <<>>}
    end
  end

  def tag(), do: :tcp

  def fake_message(sock, buffer), do: {:tcp, sock, buffer}

  def receive(_sock, {:tcp, _, blob}), do: blob

  def setopts(sock, opts), do: :inet.setopts(sock, opts)

  def send(sock, data), do: :gen_tcp.send(sock, data)

  def close(sock), do: :gen_tcp.close(sock)
end
