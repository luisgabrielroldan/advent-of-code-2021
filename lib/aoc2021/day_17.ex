defmodule Aoc2021.Day17 do
  use Aoc2021

  @regex_parse ~r/x=(\-*\d{1,})..(\-*\d{1,}), y=(\-*\d{1,})..(\-*\d{1,})/

  def part1 do
    {_x1, x2, y1, _y2} = area = load_target_area()

    for(xv <- 1..x2, yv <- y1..(1 - y1), do: {xv, yv})
    |> Enum.reduce(0, fn speed, max_y ->
      case fire({0, 0}, speed, area) do
        :missed -> max_y
        y -> max(y, max_y)
      end
    end)
  end

  def part2 do
    {_x1, x2, y1, _y2} = area = load_target_area()

    for(xv <- 1..x2, yv <- y1..(1 - y1), do: {xv, yv})
    |> Enum.reduce([], fn speed, acc ->
      case fire({0, 0}, speed, area) do
        :missed -> acc
        _ -> [speed | acc]
      end
    end)
    |> length()
  end

  defp fire({x, y} = _position, {xv, yv} = _speed, {_x1, _x2, y1, y2} = target_area, max_y \\ 0) do
    {_x, y} = position = {x + xv, y + yv}
    speed = {drag(xv), yv - 1}

    max_y = max(max_y, y)

    cond do
      in_area?(target_area, position) ->
        max_y

      y < min(y1, y2) ->
        :missed

      true ->
        fire(position, speed, target_area, max_y)
    end
  end

  defp in_area?({x1, x2, y1, y2}, {x, y}),
    do: x in x1..x2 and y in y1..y2

  defp drag(0), do: 0
  defp drag(speed), do: speed - div(speed, abs(speed))

  defp load_target_area do
    [line] = fetch_input!(17)

    [[_ | coords]] = Regex.scan(@regex_parse, line)

    {_, _, _, _} =
      coords
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
  end
end
