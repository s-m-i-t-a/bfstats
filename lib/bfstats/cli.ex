defmodule Bfstats.CLI do
  @moduledoc """
  Handle command line parsing
  """

  def main(argv) do
    argv
      |> parse
      |> process
  end

  def parse(argv) do
    parse = OptionParser.parse(
      argv,
      switches: [
        help: :boolean
      ],
      aliases: [
        h: :help
      ]
    )

    case parse do
      {[help: true], _, _} -> :help
      {_, [file], _} -> {file}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: bfstats <BeFocusedLog.csv>
    """

    System.halt(0)
  end

  def process({file}) do
    IO.puts file
    System.halt(0)
  end
end
