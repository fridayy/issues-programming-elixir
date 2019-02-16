defmodule HTTP do
  @moduledoc """
  Abstraction over HTTP libraries configured via configs (dev,test,prod)
  """
  @type url :: String
  @type header :: [{binary, binary}]
  @type response :: {atom, Map}
  @callback get(url, header) :: response
end
