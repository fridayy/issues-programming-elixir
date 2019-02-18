defmodule Issues.CLI do
  alias Issues.GithubIssues, as: GithubIssues
  @default_count 4

  def main(argv) do
    argv
    |> parse()
    |> process()
  end

  def parse(argv) do
    argv
    |> OptionParser.parse!(switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> handle_args()
  end

  defp handle_args([user, project, count]), do: {user, project, String.to_integer(count)}
  defp handle_args([user, project]), do: {user, project, @default_count}
  defp handle_args(_), do: :help

  defp process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  defp process({user, project, count}) do
    {user, project, count}
    |> GithubIssues.fetch()
    |> Issues.Printer.print()
  end
end
