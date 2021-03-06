defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir benjamin.krenn@leftshift.one"}]
  @github_url Application.get_env(:issues, :github_url)
  @http_client Application.get_env(:issues, :http_client)

  require Logger

  def fetch({user, project, count}) do
    Logger.info("fetching #{count} issues for #{user}/#{project}")
    {user, project}
    |> issues_url()
    |> @http_client.get(@user_agent)
    |> handle_response
    |> extract_or_error
    |> Stream.take(count)
    |> Stream.map(&to_issue/1)
    |> Enum.to_list()
  end

  defp issues_url({user, project}),
    do: "#{@github_url}/repos/#{user}/#{project}/issues?state=open&sort=created&direction=asc"

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

  defp extract_or_error({:error, _}) do
    Logger.error("Could not find user / project or the combination.")
    :timer.sleep(100)
    System.halt(2)
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
