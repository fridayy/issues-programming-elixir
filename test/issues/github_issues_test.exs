defmodule GithubIssuesTest do
    use ExUnit.Case

    test "successfull fetch returns expected result" do
      assert Issues.GithubIssues.fetch("x", "y") == {:ok, %{"hello" => "world"}}
    end
  end
