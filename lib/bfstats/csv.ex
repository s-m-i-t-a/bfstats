defmodule Bfstats.CSV do
  @moduledoc """
  A *Be Focused* csv reader.
  """

  require Logger

  def read(filename) do
    filename
    |> File.read()
    |> Result.map(&split/1)
    |> Result.map(&CSV.decode/1)  # {:ok, stream}
    |> process()
  end

  # Lines in file from *Be Focused* is seperated only with \r :/
  defp split(content) do
    content
    |> String.split("\r")
  end

  defp parse_datetime(datetime) do
    Timex.parse(datetime, "%e %b %Y at %H:%M:%S", :strftime)
  end

  defp parse_duration(duration) do
    duration
    |> Integer.parse()
    |> to_result()
  end

  defp to_result({val, _}) do
    {:ok, val}
  end

  defp to_result(:error) do
    {:error, "Not a number..."}
  end

  defp parse_description(description) do
    description
    |> String.split("@")
    |> Enum.map(&String.trim/1)
    |> complement()
    |> Result.ok()
  end

  defp process({:ok, stream}) do
    stream
    |> Stream.drop_while(&skip_head/1)
    |> Stream.map(&process_line/1)
    |> Stream.map(&log_error/1)
    |> Stream.map(fn(r) -> Result.with_default(r, nil) end)
    |> Stream.reject(&is_nil/1)
  end

  defp process(error) do
    error
  end

  defp skip_head({:ok, [_datetime, duration, _description, _state]}) do
    Integer.parse(duration) == :error
  end

  defp skip_head(error) do
    error
  end

  defp process_line({:ok, [datetime, duration, description, state]}) do
    [
      parse_datetime(datetime),
      parse_duration(duration),
      parse_description(description),
      {:ok, state}
    ]
    |> Result.fold()
    |> Result.map(&List.flatten/1)
  end

  defp process_line(error) do
    error
  end

  defp complement([]) do
    ["", ""]
  end

  defp complement([first]) do
    [first, ""]
  end

  defp complement([_first, _second] = description) do
    description
  end

  defp log_error({:error, msg} = result) do
    Logger.error(fn -> msg end)
    result
  end

  defp log_error(result) do
    result
  end
end
