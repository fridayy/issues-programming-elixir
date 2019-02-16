defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir benjamin.krenn@leftshift.one"}]
  @github_url Application.get_env(:issues, :github_url)
  @http_client Application.get_env(:issues, :http_client)

  def fetch(user, project) do
    issues_url(user, project)
    |> @http_client.get(@user_agent)
    |> handle_response
  end

  defp issues_url(user, project), do: "#{@github_url}/repos/#{user}/#{project}/issues"

  def handle_response({:ok, %{body: body, status_code: status_code}}) do
    {
      status_code |> check_status,
      body |> Poison.Parser.parse!(%{})
    }
  end

  def handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

  defp check_status(200), do: :ok
  defp check_status(_), do: :error
end
