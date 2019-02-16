defmodule Issues.CLI do
  alias Issues.GithubIssues, as: GithubIssues
  @default_count 4

  def main(argv) do
    parse(argv)
    |> process()
  end

  def parse(argv) do
    OptionParser.parse!(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
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

  defp process({user, project, _count}) do
    GithubIssues.fetch(user, project)
      |> decode_response()
  end

  defp decode_response({:ok, body}), do: body
  defp decode_response({:error, error}) do
    IO.puts(:stderr, "An error occurred while fetching from Github: #{error["message"]}")
    System.halt(2)
  end
end
