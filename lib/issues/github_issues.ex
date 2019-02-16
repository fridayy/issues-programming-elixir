defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir benjamin.krenn@leftshift.one"}]
  @github_url Application.get_env(:issues, :github_url)
  @http_client Application.get_env(:issues, :http_client)

  def fetch({user, project, count}) do
    {user, project}
    |> issues_url()
    |> @http_client.get(@user_agent)
    |> handle_response
    |> extract_or_error
    |> sort_ascending
    |> last(count)
    |> Enum.map(&to_issue/1)
    |> Issues.Printer.print
  end

  defp issues_url({user, project}),
    do: "#{@github_url}/repos/#{user}/#{project}/issues?state=open"

  defp handle_response({:ok, %{body: body, status_code: status_code}}) do
    {
      status_code |> check_status,
      body |> Poison.Parser.parse!(%{})
    }
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

  defp extract_or_error({:ok, issues}), do: issues

  defp extract_or_error({:err, reason}) do
    IO.puts("An error occurred: #{reason}")
  end

  defp sort_ascending(issues) do
    issues
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end

  defp last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  defp to_issue(map) do
    %Issues.Issue{
      number: Map.get(map, "number"),
      created_at: Map.get(map, "created_at"),
      title: Map.get(map, "title")
    }
  end

  defp check_status(200), do: :ok
  defp check_status(_), do: :error
end
