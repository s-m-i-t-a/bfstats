defmodule Bfstats.CLI do
  @moduledoc """
  Handle command line parsing
  """

  alias Bfstats.CSV
  alias Bfstats.Compute

  @header ["Project", "Time [h]"]

  def main(argv) do
    argv
      |> parse
      |> process
  end

  def parse(argv) do
    parse = OptionParser.parse(
      argv,
      switches: [
        help: :boolean,
        from: :string,
        to: :string,
      ],
      aliases: [
        h: :help
      ]
    )

    case parse do
      {[help: true], _, _} -> :help
      {[], [file], _} -> {file, nil, nil}
      {
        [from: from],
        [file],
        _
      } -> {file, from, nil}
      {
        [to: to],
        [file],
        _
      } -> {file, nil, to}
      {
        [from: from, to: to],
        [file],
        _
      } -> {file, from, to}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: bfstats [--from date] [--to date] <BeFocusedLog.csv>
    """

    System.halt(0)
  end

  def process({file, nil, nil}) do

    file
    |> CSV.read()
    |> Compute.group()
    |> Compute.sum_project_duration()
    |> print_table()

    System.halt(0)
  end

  def process({file, from, nil}) do
    file
    |> CSV.read()
    |> Compute.from(from)
    |> Compute.group()
    |> Compute.sum_project_duration()
    |> print_table()

    System.halt(0)
  end

  def process({file, nil, to}) do
    file
    |> CSV.read()
    |> Compute.to(to)
    |> Compute.group()
    |> Compute.sum_project_duration()
    |> print_table()

    System.halt(0)
  end

  def process({file, from, to}) do
    file
    |> CSV.read()
    |> Compute.from(from)
    |> Compute.to(to)
    |> Compute.group()
    |> Compute.sum_project_duration()
    |> print_table()

    System.halt(0)
  end

  defp print_table(data) do
    table =
      data
      |> TableRex.quick_render!(@header)

    IO.puts("\n#{table}\n")
  end
end
