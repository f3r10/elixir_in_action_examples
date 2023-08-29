defmodule TodoList.CsvImporter do
  def import(file_name) do
    File.stream!(file_name)
    |> Stream.map(fn line -> String.replace(line, "\n", "") end)
    |> Stream.map(fn line ->
      [date, title] = String.split(line, ",")

      [year, month, day] =
        String.split(date, "/")
        |> Enum.map(fn el -> String.to_integer(el) end)

      {:ok, date} = Date.new(year, month, day)
      TodoEntry.new(date, title)
    end)
    |> TodoList.new()
    |> IO.inspect()
  end
end

defmodule TodoEntry do
  defstruct date: {}, title: String

  def new(date, title), do: %TodoEntry{date: date, title: title}
end

defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new()

  # def new, do: %TodoList{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list_acc ->
        add_entry(todo_list_acc, entry)
      end
    )
  end

  @spec add_entry(%TodoList{}, %TodoEntry{}) :: %TodoList{}
  def add_entry(
        %TodoList{entries: entries, auto_id: auto_id} = todo_list,
        %TodoEntry{} = entry
      ) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    %TodoList{todo_list | auto_id: auto_id + 1, entries: new_entries}
  end

  def entries(
        %TodoList{entries: entries},
        date
      ) do
    entries
    |> Stream.filter(fn {_, entry} ->
      entry.date == date
    end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  @spec update_entry(
          %TodoList{},
          integer,
          (existing_value :: %TodoList{} -> new_value :: %TodoList{})
        ) :: %TodoList{}
  def update_entry(
        %TodoList{entries: entries} = todo_list,
        entry_id,
        updated_fun
      ) do
    case entries[entry_id] do
      nil ->
        todo_list

      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updated_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  @spec delete_entry(%TodoList{}, integer) :: %TodoList{}
  def delete_entry(%TodoList{entries: entries} = todo_list, entry_id) do
    new_entries = Map.delete(entries, entry_id)
    %TodoList{todo_list | entries: new_entries}
  end
end
