defmodule Http2serverWeb.DataController do
  use Http2serverWeb, :controller

  @total_size 10 * 1024 * 1024  # 10 MB
  @chunk_size 32 * 1024         # 32 KB
  @printable_chars Enum.to_list(?\s..?~) # 32..126 ASCII printable
  @large_random_binary :binary.list_to_bin(
    for _ <- 1..10_000_000, do: Enum.random(@printable_chars)
  )

  def stream(conn, _params) do
    conn = put_resp_content_type(conn, "text/plain")
    conn = send_chunked(conn, 200)

    do_stream(conn, 0)
  end

  defp do_stream(conn, sent) when sent >= @total_size do
    conn
  end

  defp do_stream(conn, sent) do
    chunk_size = min(@chunk_size, @total_size - sent)

    chunk = random_printable_chunk(chunk_size)

    case chunk(conn, chunk) do
      {:ok, conn} ->
        do_stream(conn, sent + chunk_size)

      {:error, _reason} ->
        # Client disconnected or error - stop streaming
        conn
    end
  end

  def random_printable_chunk(size) do
    binary_part(@large_random_binary, 0, size)
  end
end
