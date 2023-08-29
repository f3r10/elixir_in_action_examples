defmodule TodoServerGen do
  def start do
    ServerProcess.start(TodoServerGen)
  end

  def init do
    TodoList.new()
  end

  def add_entry(pid, %TodoEntry{} = new_entry) do
    ServerProcess.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  def handle_cast({:add_entry, new_entry}, state) do
    TodoList.add_entry(state, new_entry)
  end

  def handle_call({:entries, date}, state) do
    {TodoList.entries(state, date), state}
  end
end
