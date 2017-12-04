defmodule Bfstats.Compute do
  @moduledoc """
  Some computations on tasks list
  """

  def group(stream) do
    stream
    |> Enum.to_list()
    |> Enum.group_by(fn([_, _, _, project, _]) -> project end)
  end

  def from(stream, date) do
    stream
    |> Stream.reject(
      fn([task_date | _]) ->
        Timex.compare(task_date, to_date(date)) == -1
      end
    )
  end

  def to(stream, date) do
    stream
    |> Stream.reject(
      fn([task_date | _]) ->
        Timex.compare(task_date, to_date(date), :days) == 1
      end
    )
  end

  def sum_project_duration(map) do
    map
    |> Enum.map(
      fn({project, tasks}) ->
        [
          project,
          tasks
          |> Enum.reduce(0, fn([_, time, _, _, _], acc) -> acc + time end)
          |> to_hours()
        ]
      end
    )
  end

  defp to_date(date) do
    date
    |> Timex.parse!("%Y-%m-%d", :strftime)
  end

  defp to_hours(minutes) do
    Float.round(minutes / 60, 2)
  end
end
