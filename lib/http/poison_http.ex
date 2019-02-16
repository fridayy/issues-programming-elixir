defmodule HTTP.PoisonHTTP do
  @behaviour HTTP

  def get(url, header), do: HTTPoison.get(url, header)

end
