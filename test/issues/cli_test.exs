defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  test "parse/1 returns the expected internal representation" do
    parameterized = fn input, expectation -> assert Issues.CLI.parse(input) == expectation end
    parameterized.(["fridayy", "issues", "2"], {"fridayy", "issues", 2})
    parameterized.(["fridayy", "issues"], {"fridayy", "issues", 4})
    parameterized.(["--help"], :help)
  end
end
