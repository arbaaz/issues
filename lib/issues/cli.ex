defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_represention()
  end

  def process(:help) do
    IO.puts("""
      usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def decode_response({:ok, _}), do: :ok

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def args_to_internal_represention([user, project, count]) do
    {user, project, count}
  end

  def args_to_internal_represention([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_represention(_) do
    :help
  end
end
