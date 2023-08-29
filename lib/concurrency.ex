defmodule Concurrency do
  def run_query(query_def) do
    :timer.sleep(2000)
    "#{query_def} result"
  end

  def run_multiple_seq_queries do
    1..5
    |> Enum.map(&run_query("query #{&1}"))
  end

  def async_query(query_def) do
    caller = self()
    spawn(fn -> send(caller, {:query_result, run_query(query_def)}) end)
  end

  def run_multiple_async_queries do
    Enum.each(1..5, &async_query("query #{&1}"))
  end

  def get_result() do
    receive do
      {:query_result, result} -> result
    end
  end

  def fibTR(num) do
    fibFcn(num, 0, 1)
  end

  defp fibFcn(n, acc1, acc2) do
    case n do
      0 -> acc1
      1 -> acc2
      _ -> fibFcn(n - 1, acc2, acc1 + acc2)
    end
  end
end
