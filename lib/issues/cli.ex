defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_represention()
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
