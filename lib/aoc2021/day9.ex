defmodule Aoc2021.Day9 do
  use Aoc2021

  def part1 do
    {map, width, height} = load_map()

    map
    |> get_low_points(width, height)
    |> Enum.map(fn {x, y} -> Map.get(map, {x, y}) end)
    |> Enum.map(&risk_level/1)
    |> Enum.sum()
  end

  def part2 do
    {map, width, height} = load_map()

    map
    |> get_low_points(width, height)
    |> Enum.map(fn {x, y} -> get_basin(map, x, y) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp get_basin(map, x, y, acc \\ MapSet.new())

  defp get_basin(map, x, y, acc) do
    level = Map.get(map, {x, y})

    if is_nil(level) or level == 9 or MapSet.member?(acc, {x, y}) do
      acc
    else
      acc = MapSet.put(acc, {x, y})

      acc = get_basin(map, x - 1, y, acc)
      acc = get_basin(map, x + 1, y, acc)
      acc = get_basin(map, x, y - 1, acc)

      get_basin(map, x, y + 1, acc)
    end
  end

  defp get_low_points(map, width, height) do
    for x <- 0..(width - 1), y <- 0..(height - 1) do
      {x, y}
    end
    |> Enum.filter(fn {x, y} ->
      low_point?(map, x, y)
    end)
  end

  defp low_point?(map, x, y) do
    point_height = Map.get(map, {x, y})

    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(&Map.get(map, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.all?(&(&1 > point_height))
  end

  defp risk_level(level), do: level + 1

  defp load_map do
    [line | _] = input = fetch_input!(9)

    width = String.length(line)
    height = length(input)

    map =
      input
      |> Enum.with_index(0)
      |> Enum.map(fn {line, y} ->
        line
        |> String.codepoints()
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index(0)
        |> Enum.map(fn {v, x} -> {{x, y}, v} end)
      end)
      |> List.flatten()
      |> Map.new()

    {map, width, height}
  end
end
