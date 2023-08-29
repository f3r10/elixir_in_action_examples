defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(caller_pid) do
    send(caller_pid, {:value, self()})

    receive do
      {:response, value} -> value
    end
  end

  def add(caller_pid, value), do: send(caller_pid, {:add, value})
  def sub(caller_pid, value), do: send(caller_pid, {:sub, value})
  def mul(caller_pid, value), do: send(caller_pid, {:mul, value})
  def div(caller_pid, value), do: send(caller_pid, {:div, value})

  defp loop(current_value) do
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, current_value})
          current_value

        {:add, value} ->
          current_value + value

        {:sub, value} ->
          current_value - value

        {:mul, value} ->
          current_value * value

        {:div, value} ->
          current_value / value

        invalid_request ->
          IO.puts("invalid request #{inspect(invalid_request)}")
          current_value
      end

    loop(new_value)
  end
end
