defmodule Aoc2021.Day12 do
  use Aoc2021

  def part1 do
    load_graph()
    |> walk_part1("start", [])
    |> length()
  end

  def part2 do
    load_graph()
    |> walk_part2("start", [])
    |> length()
  end

  defp walk_part1(_graph, "end", path) do
    Enum.reverse(["end" | path]) |> List.to_tuple()
  end

  defp walk_part1(graph, current, path) do
    if is_big(current) or total_visits(path, current) == 0 do
      graph
      |> Map.fetch!(current)
      |> Enum.map(&walk_part1(graph, &1, [current | path]))
      |> List.flatten()
    else
      []
    end
  end

  defp walk_part2(_graph, "end", path) do
    Enum.reverse(["end" | path]) |> List.to_tuple()
  end

  defp walk_part2(graph, current, path) do
    if is_big(current) or can_revisit?(path) or total_visits(path, current) == 0 do
      graph
      |> Map.fetch!(current)
      |> Enum.map(&walk_part2(graph, &1, [current | path]))
      |> List.flatten()
    else
      []
    end
  end

  defp can_revisit?(path) do
    small_visited = Enum.reject(path, &is_big/1)
    length(small_visited) == length(Enum.uniq(small_visited))
  end

  defp total_visits(path, cave) do
    Enum.filter(path, fn c -> c == cave end) |> length()
  end

  defp load_graph do
    fetch_input!(12)
    |> Enum.map(fn line ->
      String.split(line, "-") |> List.to_tuple()
    end)
    |> Enum.flat_map(fn {a, b} -> [{a, b}, {b, a}] end)
    |> Enum.reject(fn {_a, b} -> b == "start" end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  def is_big(cave), do: String.upcase(cave) == cave
end
