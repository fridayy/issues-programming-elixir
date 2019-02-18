defmodule Issues.Printer do
  @moduledoc """
  Pretty prints the given list of issues.
  Diverges a bit from the exercise for simplicity (I am lazy) reasons
  """
  @max_title_length 50

  @type issues :: [Issues.Issue]
  @spec print(issues) :: :ok
  def print(issues) do
    pretty = issues
    |> Enum.reduce("""
      # \t created_at \t\t title
    """,
    fn val, acc ->
      acc <> "#{Integer.to_string(val.number)}\t#{val.created_at}\t#{format_title(val.title)}\n"
    end)
    IO.puts(pretty)
  end

  defp format_title(title) do
    if String.length(title) > @max_title_length do
       title |> String.slice(0..@max_title_length) |> Kernel.<>("...")
    else
      title
    end
  end

end
