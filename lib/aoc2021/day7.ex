defmodule Aoc2021.Day7 do
  use Aoc2021

  def part1 do
    crabs_from_input()
    |> minimize_fuel(&fuel_strategy_1/2)
  end

  def part2 do
    crabs_from_input()
    |> minimize_fuel(&fuel_strategy_2/2)
  end

  defp fuel_strategy_1(crabs, x),
    do: Enum.reduce(crabs, 0, &(&2 + abs(&1 - x)))

  defp fuel_strategy_2(crabs, x),
    do: Enum.reduce(crabs, 0, &(&2 + Enum.sum(0..abs(&1 - x))))

  defp minimize_fuel(crabs, fuel_fun) do
    max_x = Enum.sort(crabs) |> Enum.reverse() |> hd()

    Enum.reduce(0..max_x, nil, &do_minimize_fuel(crabs, fuel_fun, &1, &2))
  end

  defp do_minimize_fuel(crabs, fuel_fun, x, nil),
    do: fuel_fun.(crabs, x)

  defp do_minimize_fuel(crabs, fuel_fun, x, last_min) do
    crabs
    |> fuel_fun.(x)
    |> min(last_min)
  end

  defp crabs_from_input do
    fetch_input!(7)
    |> hd()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
