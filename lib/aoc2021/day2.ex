defmodule Aoc2021.Day2 do
  use Aoc2021

  def part1 do
    fetch_input!(2)
    |> parse()
    |> navigate(0, 0)
  end

  def part2 do
    fetch_input!(2)
    |> parse()
    |> navigate_with_aim(0, 0, 0)
  end

  defp parse(input) do
    input
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [dir, steps] ->
      {dir, String.to_integer(steps)}
    end)
  end

  defp navigate([], horizontal, depth),
    do: horizontal * depth

  defp navigate([{"forward", x} | rest], horizontal, depth),
    do: navigate(rest, horizontal + x, depth)

  defp navigate([{"up", x} | rest], horizontal, depth),
    do: navigate(rest, horizontal, depth - x)

  defp navigate([{"down", x} | rest], horizontal, depth),
    do: navigate(rest, horizontal, depth + x)

  defp navigate_with_aim([], horizontal, depth, _aim),
    do: horizontal * depth

  defp navigate_with_aim([{"forward", x} | rest], horizontal, depth, aim),
    do: navigate_with_aim(rest, horizontal + x, depth + aim * x, aim)

  defp navigate_with_aim([{"up", x} | rest], horizontal, depth, aim),
    do: navigate_with_aim(rest, horizontal, depth, aim - x)

  defp navigate_with_aim([{"down", x} | rest], horizontal, depth, aim),
    do: navigate_with_aim(rest, horizontal, depth, aim + x)
end
