defmodule HTTP.InMemoryHTTP do
  @moduledoc """
  Mocked HTTP only used in test environment
  """
  @behaviour HTTP

  def get(url, header) do
    {:ok, %{body: ~s({ "hello" : "world" }), status_code: 200}}
  end

end
