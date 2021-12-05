defmodule Aoc2021.Day5 do
  use Aoc2021

  def part1 do
    fetch_input!(5)
    |> parse_lines()
    |> Enum.reduce(%{}, fn {{x1, y1}, {x2, y2}}, map ->
      draw_line(map, x1, y1, x2, y2)
    end)
    |> Enum.filter(fn {_, i} -> i >= 2 end)
    |> length()
  end

  def part2 do
    fetch_input!(5)
    |> parse_lines()
    |> Enum.reduce(%{}, fn {{x1, y1}, {x2, y2}}, map ->
      draw_line(map, x1, y1, x2, y2, true)
    end)
    |> Enum.filter(fn {_, i} -> i >= 2 end)
    |> length()
  end

  defp parse_lines(input) do
    input
    |> Enum.map(&String.split(&1, ~r/[->,\s]/, trim: true))
    |> Enum.map(fn line ->
      [x1, y1, x2, y2] = Enum.map(line, &String.to_integer/1)

      {{x1, y1}, {x2, y2}}
    end)
  end

  defp draw_line(map, x1, y1, x2, y2, diagonals \\ false) do
    cond do
      x1 == x2 ->
        Enum.reduce(y1..y2, map, fn py, map1 ->
          Map.update(map1, {x1, py}, 1, fn v -> v + 1 end)
        end)

      y1 == y2 ->
        Enum.reduce(x1..x2, map, fn px, map1 ->
          Map.update(map1, {px, y1}, 1, fn v -> v + 1 end)
        end)

      diagonals ->
        dx = x2 - x1
        dy = y2 - y1

        Enum.reduce(x1..x2, map, fn x, map1 ->
          y = trunc(y1 + dy * (x - x1) / dx)
          Map.update(map1, {x, y}, 1, fn v -> v + 1 end)
        end)

      true ->
        map
    end
  end
end
