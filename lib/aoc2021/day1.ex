defmodule Aoc2021.Day1 do
  use Aoc2021

  def part1 do
    fetch_input!(1, 1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> count_increases_part1()
  end

  def part2 do
    fetch_input!(1, 1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> count_increases_part2()
  end

  defp count_increases_part2(list, last \\ nil, acc \\ 0)

  defp count_increases_part2([_, _], _last, acc),
    do: acc

  defp count_increases_part2([a, b, c | rest], nil, acc),
    do: count_increases_part2([b, c] ++ rest, a + b + c, acc)

  defp count_increases_part2([a, b, c | rest], last, acc) when a + b + c > last,
    do: count_increases_part2([b, c] ++ rest, a + b + c, acc + 1)

  defp count_increases_part2([a, b, c | rest], _last, acc),
    do: count_increases_part2([b, c] ++ rest, a + b + c, acc)

  defp count_increases_part1(list, last \\ nil, acc \\ 0)

  defp count_increases_part1([], _last, acc),
    do: acc

  defp count_increases_part1([v | rest], nil, acc),
    do: count_increases_part1(rest, v, acc)

  defp count_increases_part1([v | rest], last, acc) when v > last,
    do: count_increases_part1(rest, v, acc + 1)

  defp count_increases_part1([v | rest], _last, acc),
    do: count_increases_part1(rest, v, acc)
end
