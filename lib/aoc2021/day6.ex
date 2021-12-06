defmodule Aoc2021.Day6 do
  use Aoc2021

  def part1 do
    fetch_input!(6)
    |> build_fishes()
    |> simulate(80)
    |> count_fishes()
  end

  def part2 do
    fetch_input!(6)
    |> build_fishes()
    |> simulate(256)
    |> count_fishes()
  end

  defp simulate(fishes, 0), do: fishes

  defp simulate(fishes, days_left) do
    fishes
    |> Enum.reduce(fishes, fn
      {0, count}, fishes1 ->
        fishes1
        |> Map.update(0, 0, & &1 - count)
        |> Map.update(6, count, & &1 + count)
        |> Map.update(8, count, & &1 + count)

      {fish, count}, fishes1 ->
        fishes1
        |> Map.update(fish, 0, & &1 - count)
        |> Map.update(fish - 1, count, & &1 + count)
    end)
    |> simulate(days_left - 1)
  end

  defp count_fishes(fishes) do
    Enum.reduce(fishes, 0, fn {_, count}, acc -> acc + count end)
  end

  defp build_fishes(input) do
    input
    |> hd()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn c -> c + 1 end))
  end
end
