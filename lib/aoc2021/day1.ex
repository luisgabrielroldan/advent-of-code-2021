defmodule Aoc2021.Day1 do
  use Aoc2021

  def part1 do
    fetch_input!(1, 1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> count_increases()
  end

  def part2 do
    fetch_input!(1, 1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> windowize()
    |> count_increases()
  end

  defp windowize(list, acc \\ [])

  defp windowize([_, _], acc),
    do: Enum.reverse(acc)

  defp windowize([a, b, c | rest], acc),
    do: windowize([b, c] ++ rest, [a + b + c | acc])

  defp count_increases(list, last \\ nil, acc \\ 0)

  defp count_increases([], _last, acc),
    do: acc

  defp count_increases([v | rest], nil, acc),
    do: count_increases(rest, v, acc)

  defp count_increases([v | rest], last, acc) when v > last,
    do: count_increases(rest, v, acc + 1)

  defp count_increases([v | rest], _last, acc),
    do: count_increases(rest, v, acc)
end
