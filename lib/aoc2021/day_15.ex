defmodule Aoc2021.Day15 do
  use Aoc2021

  def part1 do
    {map, width, height} = load_map()

    graph =
      map
      |> build_graph()
      |> Map.put({0, 0}, {0, false, 0})
      |> dijkstra(0, 0)

    {_, _, dist} = Map.get(graph, {width - 1, height - 1})

    dist
  end

  def part2 do
    {map, width, height} = load_map()
    {map, width, height} = graph_tiles(map, width, height, 5)

    graph =
      map
      |> build_graph()
      |> Map.put({0, 0}, {0, false, 0})
      |> dijkstra(0, 0)

    {_, _, dist} = Map.get(graph, {width - 1, height - 1})

    dist
  end

  defp graph_tiles(graph, width, height, factor) do
    graph =
      for dx <- 0..(factor - 1), dy <- 0..(factor - 1) do
        {dx, dy}
      end
      |> Enum.reduce(graph, fn {dx, dy}, graph1 ->
        for x <- 0..(width - 1), y <- 0..(height - 1) do
          new_risk =
            case Map.fetch!(graph, {x, y}) + dx + dy do
              v when v > 9 -> v - 9
              v -> v
            end

          {{x + dx * width, y + dy * height}, new_risk}
        end
        |> Map.new()
        |> Map.merge(graph1)
      end)

    {graph, width * factor, height * factor}
  end

  defp dijkstra(graph, x, y) do
    graph =
      graph
      |> adjacents(x, y)
      |> Enum.reduce(graph, fn {nx, ny}, graph1 ->
        {_, _, dp} = Map.fetch!(graph1, {x, y})
        {edge, visited, dt1} = Map.fetch!(graph, {nx, ny})

        Map.put(graph1, {nx, ny}, {edge, visited, min(dt1, dp + edge)})
      end)
      |> Map.update({x, y}, nil, fn {e, _, d} -> {e, true, d} end)

    case next(graph) do
      {nx, ny} ->
        dijkstra(graph, nx, ny)

      :end ->
        graph
    end
  end

  defp next(graph) do
    graph
    |> Enum.reject(fn {_coord, {_edge, visited, _dist}} -> visited end)
    |> case do
      [] ->
        :end

      nodes ->
        {coord, _} = Enum.min_by(nodes, fn {_coord, {_edge, _visited, dist}} -> dist end)
        coord
    end
  end

  defp adjacents(graph, x, y) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      case Map.get(graph, {x, y}) do
        {_, false, _} -> true
        _ -> false
      end
    end)
  end

  defp build_graph(map) do
    Map.new(map, fn {{x, y}, edge} -> {{x, y}, {edge, false, nil}} end)
  end

  defp load_map do
    [line | _] = input = fetch_input!(15)

    width = String.length(line)
    height = length(input)

    graph =
      input
      |> Enum.with_index(0)
      |> Enum.map(fn {line, y} ->
        line
        |> String.codepoints()
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index(0)
        |> Enum.map(fn {edge, x} -> {{x, y}, edge} end)
      end)
      |> List.flatten()
      |> Map.new()

    {graph, width, height}
  end
end
