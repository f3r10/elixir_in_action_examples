defmodule TodoServerGenServer do
  use GenServer

  def init(_) do
    {:ok, TodoList.new()}
  end

  def start do
    GenServer.start(TodoServerGenServer, nil)
  end

  def add_entry(pid, %TodoEntry{} = new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def handle_cast({:add_entry, new_entry}, state) do
    {:noreply, TodoList.add_entry(state, new_entry)}
  end

  def handle_call({:entries, date}, _, state) do
    {:reply, TodoList.entries(state, date), state}
  end
end
