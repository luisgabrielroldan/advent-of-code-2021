defmodule Aoc2021.Day13 do
  use Aoc2021

  def part1 do
    {points, folds} = load_input()
    [first_fold | _rest] = folds

    points = fold(points, first_fold)

    MapSet.size(points)
  end

  def part2 do
    {points, folds} = load_input()

    folds
    |> Enum.reduce(points, fn fold, points1 ->
      fold(points1, fold)
    end)
    |> render_points()

    :ok
  end

  defp render_points(points) do
    map = Map.new(points, fn point -> {point, true} end)
    width = Enum.map(points, fn {x, _y} -> x end) |> Enum.max()
    height = Enum.map(points, fn {_x, y} -> y end) |> Enum.max()

    Enum.each(0..height, fn y ->
      Enum.map(0..width, fn x -> if map[{x, y}], do: "#", else: " " end)
      |> IO.puts()
    end)
  end

  defp fold(points, {"x", value}) do
    Enum.reduce(points, MapSet.new(), fn
      {x, y}, acc when x >= value ->
        MapSet.put(acc, {value - (x - value), y})

      point, acc ->
        MapSet.put(acc, point)
    end)
  end

  defp fold(points, {"y", value}) do
    Enum.reduce(points, MapSet.new(), fn
      {x, y}, acc when y >= value ->
        MapSet.put(acc, {x, value - (y - value)})

      point, acc ->
        MapSet.put(acc, point)
    end)
  end

  defp load_input do
    input = fetch_input!(13)

    %{points: points, folds: folds} =
      input
      |> Enum.reduce_while([], fn
        "", acc ->
          {:cont, acc}

        "fold along " <> s, acc ->
          [a, b] = String.split(s, "=")
          fold = {:folds, {a, String.to_integer(b)}}

          {:cont, [fold | acc]}

        line, acc ->
          [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)

          {:cont, [{:points, {x, y}} | acc]}
      end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    {MapSet.new(points), Enum.reverse(folds)}
  end
end
