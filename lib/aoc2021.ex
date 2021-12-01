defmodule Aoc2021 do
  @moduledoc """
  Advent of Code 2021
  """

  defmacro __using__(_) do
    quote do
      import Aoc2021
    end
  end

  def fetch_input!(day, part, parser \\ :lines) do
    day = String.pad_leading("#{day}", 2, "0")

    [
      :code.priv_dir(:aoc2021),
      "inputs",
      "day_#{day}_#{part}.txt"
    ]
    |> Path.join()
    |> File.read!()
    |> String.trim()
    |> parse(parser)
  end

  defp parse(input, :none) do
    input
  end

  defp parse(input, :lines) do
    String.split(input, "\n")
  end
end
