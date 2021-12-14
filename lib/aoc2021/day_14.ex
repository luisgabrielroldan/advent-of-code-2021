defmodule Aoc2021.Day14 do
  use Aoc2021

  def part1 do
    {template, rules} = load_input()

    {_pairs, chars} = polymerize(template, rules, 10)

    {_, least_count} = Enum.min_by(chars, &elem(&1, 1))
    {_, most_count} = Enum.max_by(chars, &elem(&1, 1))

    most_count - least_count
  end

  def part2 do
    {template, rules} = load_input()

    {_pairs, chars} = polymerize(template, rules, 40)

    {_, least_count} = Enum.min_by(chars, &elem(&1, 1))
    {_, most_count} = Enum.max_by(chars, &elem(&1, 1))

    most_count - least_count
  end

  def polymerize(template, rules, times) do
    chars = String.graphemes(template)

    pairs =
      chars
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(%{}, fn pair, pairs1 ->
        Map.update(pairs1, pair, 1, fn v -> v + 1 end)
      end)

    chars =
      Enum.reduce(chars, %{}, fn char, chars1 ->
        Map.update(chars1, char, 1, fn v -> v + 1 end)
      end)

    Enum.reduce(1..times, {pairs, chars}, fn _step, {pairs1, chars1} ->
      Enum.reduce(pairs1, {pairs1, chars1}, fn
        {[a, b], count}, {pairs2, chars2} ->
          c = Map.fetch!(rules, [a, b])

          chars2 = Map.update(chars2, c, count, fn v -> v + count end)

          pairs2 =
            pairs2
            |> Map.update([a, b], count, fn v -> v - count end)
            |> Map.update([a, c], count, fn v -> v + count end)
            |> Map.update([c, b], count, fn v -> v + count end)

          {pairs2, chars2}
      end)
    end)
  end

  defp load_input() do
    [template, "" | rules_input] = fetch_input!(14)

    rules =
      rules_input
      |> Enum.map(&String.split(&1, " -> "))
      |> Map.new(fn [pair, ins] -> {String.graphemes(pair), ins} end)

    {template, rules}
  end
end
