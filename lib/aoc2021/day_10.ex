defmodule Aoc2021.Day10 do
  use Aoc2021

  @illegal_points %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
  @incomplete_points %{")" => 1, "]" => 2, "}" => 3, ">" => 4}
  @open_close %{"(" => ")", "[" => "]", "{" => "}", "<" => ">"}
  @open_symbols Enum.map(@open_close, fn {o, _c} -> o end)

  def part1 do
    load_input()
    |> Enum.map(&find_corrupt_points/1)
    |> Enum.flat_map(fn {r, c} -> if r == :error, do: [c], else: [] end)
    |> Enum.map(&Map.fetch!(@illegal_points, &1))
    |> Enum.sum()
  end

  def part2 do
    load_input()
    |> Enum.map(&find_corrupt_points/1)
    |> Enum.flat_map(fn {r, c} -> if r == :ok, do: [c], else: [] end)
    |> Enum.map(&completion_chars/1)
    |> Enum.map(fn chars ->
      Enum.reduce(chars, 0, fn char, acc ->
        acc * 5 + Map.fetch!(@incomplete_points, char)
      end)
    end)
    |> middle()
  end

  defp completion_chars(chars) do
    chars
    |> Enum.reduce([], fn
      c, stack when c in @open_symbols -> [c | stack]
      _, [_ | rest] -> rest
    end)
    |> Enum.map(&Map.fetch!(@open_close, &1))
  end

  defp find_corrupt_points(chars, stack \\ [], acc \\ [])

  defp find_corrupt_points([], _stack, acc),
    do: {:ok, Enum.reverse(acc)}

  defp find_corrupt_points([c | rest], stack, acc) when c in @open_symbols,
    do: find_corrupt_points(rest, [c | stack], [c | acc])

  defp find_corrupt_points([close | rest], [open | stack], acc) do
    if Map.fetch!(@open_close, open) == close do
      find_corrupt_points(rest, stack, [close | acc])
    else
      {:error, close}
    end
  end

  defp load_input do
    fetch_input!(10)
    |> Enum.map(&String.codepoints/1)
  end

  def middle(scores) do
    scores
    |> Enum.sort()
    |> Enum.at(div(length(scores), 2))
  end
end
