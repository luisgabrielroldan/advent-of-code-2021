defmodule Aoc2021.Day8 do
  use Aoc2021

  def part1 do
    load_input()
    |> Enum.reduce(0, fn [_, output], sum ->
      Enum.reduce(output, sum, fn digit, sum1 ->
        if String.length(digit) in [2, 3, 4, 7] do
          sum1 + 1
        else
          sum1
        end
      end)
    end)
  end

  def part2 do
    load_input()
    |> Enum.map(fn [pattern, output] ->
      decoder = build_digit_decoder(pattern)

      output
      |> Enum.map(decoder)
      |> Enum.map(&to_string/1)
      |> to_string()
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp build_digit_decoder(pattern) do
    lookup_map = build_lookup_map(pattern)

    fn digit ->
      lookup_map
      |> Enum.find(fn {_num, e} -> e == digit end)
      |> elem(0)
    end
  end

  defp build_lookup_map(digits) do
    {one, digits} = extract(digits, &(MapSet.size(&1) == 2))
    {four, digits} = extract(digits, &(MapSet.size(&1) == 4))
    {seven, digits} = extract(digits, &(MapSet.size(&1) == 3))
    {eight, digits} = extract(digits, &(MapSet.size(&1) == 7))

    {nine, digits} = extract(digits, fn digit -> inter_len(four, digit) == 4 end)

    {three, digits} =
      extract(digits, fn digit ->
        inter_len(seven, digit) == 3 and inter_len(eight, digit) == 5
      end)

    {two, digits} =
      extract(digits, fn digit ->
        inter_len(one, digit) == 1 and inter_len(four, digit) == 2
      end)

    {five, digits} = extract(digits, fn digit -> inter_len(two, digit) == 3 end)

    {six, [zero]} = extract(digits, fn digit -> inter_len(five, digit) == 5 end)

    %{
      0 => zero,
      1 => one,
      2 => two,
      3 => three,
      4 => four,
      5 => five,
      6 => six,
      7 => seven,
      8 => eight,
      9 => nine
    }
  end

  defp inter_len(set1, set2) do
    set1
    |> MapSet.intersection(set2)
    |> MapSet.size()
  end

  defp extract(list, fun) do
    [value] = Enum.filter(list, fun)
    rest = Enum.reject(list, &(&1 == value))
    {value, rest}
  end

  defp load_input do
    fetch_input!(8)
    |> Enum.map(fn line ->
      line
      |> String.split("|")
      |> Enum.map(fn part ->
        part
        |> String.split(" ", trim: true)
        |> Enum.map(&String.codepoints/1)
        |> Enum.map(&MapSet.new/1)
      end)
    end)
  end
end
