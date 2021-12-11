defmodule Aoc2021.Day11 do
  use Aoc2021

  @width 10
  @heigth 10
  @steps 100

  def part1 do
    map = load_map()

    {_map, flashes} =
      Enum.reduce(1..@steps, {map, 0}, fn _step, {map, flashes} ->
        {map, flashes1} = step(map)

        {map, flashes + flashes1}
      end)

    flashes
  end

  def part2 do
    load_map()
    |> first_full_flash()
  end

  defp first_full_flash(map, step \\ 1) do
    case step(map) do
      {_map, 100} ->
        step

      {map, _} ->
        first_full_flash(map, step + 1)
    end
  end

  defp step(map) do
    {map, flashes} =
      map
      |> next_power_level()
      |> handle_flashes()

    map =
      all_octopuses()
      |> Enum.reduce(map, fn octopus, map1 ->
        if is_nil(Map.fetch!(map1, octopus)) do
          Map.put(map1, octopus, 0)
        else
          map1
        end
      end)

    {map, flashes}
  end

  defp handle_flashes(map, flashes \\ 0) do
    all_octopuses()
    |> Enum.reduce({map, 0}, fn {x, y}, {map1, flashes1} ->
      level = Map.fetch!(map1, {x, y})

      if not is_nil(level) and level > 9 do
        map1 =
          map1
          |> Map.put({x, y}, nil)
          |> inc_adjacents(x, y)

        {map1, flashes1 + 1}
      else
        {map1, flashes1}
      end
    end)
    |> case do
      {map, 0} ->
        {map, flashes}

      {map, flashes1} ->
        handle_flashes(map, flashes + flashes1)
    end
  end

  defp inc_adjacents(map, x, y) do
    inc_level(map, adjacent_octopuses(x, y))
  end

  defp next_power_level(map) do
    inc_level(map, all_octopuses())
  end

  defp inc_level(map, octopuses) do
    Enum.reduce(octopuses, map, fn {x, y}, map1 ->
      if Map.get(map1, {x, y}) |> is_nil() do
        map1
      else
        Map.update(map1, {x, y}, 0, fn current -> current + 1 end)
      end
    end)
  end

  def adjacent_octopuses(x, y) do
    for dx <- -1..1, dy <- -1..1, dx != 0 or dy != 0 do
      {x + dx, y + dy}
    end
  end

  defp all_octopuses do
    for x <- 1..@width, y <- 1..@heigth do
      {x, y}
    end
  end

  defp load_map do
    fetch_input!(11)
    |> Enum.with_index(1)
    |> Enum.map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(1)
      |> Enum.map(fn {level, x} -> {{x, y}, level} end)
    end)
    |> List.flatten()
    |> Map.new()
  end
end
