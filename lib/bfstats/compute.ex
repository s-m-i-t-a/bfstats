defmodule Bfstats.Compute do
  @moduledoc """
  Some computations on tasks list
  """

  def from(stream, date) do
    stream
    |> Stream.reject(
      fn([task_date | _]) ->
        Timex.compare(task_date, to_date(date), :days) == -1
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

  defp to_date(date) do
    date
    |> Timex.parse!("%Y-%m-%d", :strftime)
  end
end
