defmodule Aoc2021.Day3 do
  use Aoc2021

  def part1 do
    input = fetch_input!(3)
    gamma_rate = calc_gamma_rate(input)
    epsilon_rate = calc_epsilon_rate(input)

    gamma_rate * epsilon_rate
  end

  def part2 do
    input = fetch_input!(3)
    calc_oxygen_rating(input) * calc_scrubber_rating(input)
  end

  defp calc_oxygen_rating(input) do
    digits = input |> List.first() |> String.length()

    Enum.reduce_while(0..(digits - 1), input, fn bit, acc ->
      case acc do
        [last] ->
          {:halt, last}

        acc ->
          case common_value_in_bit(:most, acc, bit) do
            :equal ->
              acc = Enum.filter(acc, fn e -> String.at(e, bit) == "1" end)
              {:cont, acc}

            mcv ->
              acc = Enum.filter(acc, fn e -> String.at(e, bit) == mcv end)
              {:cont, acc}
          end
      end
    end)
    |> unwrap()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp calc_scrubber_rating(input) do
    digits = input |> List.first() |> String.length()

    Enum.reduce_while(0..(digits - 1), input, fn bit, acc ->
      case acc do
        [last] ->
          {:halt, last}

        acc ->
          case common_value_in_bit(:less, acc, bit) do
            :equal ->
              acc  = Enum.filter(acc, fn e -> String.at(e, bit) == "0" end)
              {:cont, acc}

            mcv ->
              acc = Enum.filter(acc, fn e -> String.at(e, bit) == mcv end)
              {:cont, acc}
          end
      end
    end)
    |> unwrap()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp calc_gamma_rate(input) do
    input
    |> Enum.map(&to_charlist/1)
    |> Enum.zip_reduce([], fn elements, acc -> [most_common_value(elements) | acc] end)
    |> Enum.reverse()
    |> List.flatten()
    |> to_string()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp calc_epsilon_rate(input) do
    input
    |> Enum.map(&to_charlist/1)
    |> Enum.zip_reduce([], fn elements, acc -> [less_common_value(elements) | acc] end)
    |> Enum.reverse()
    |> List.flatten()
    |> to_string()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp common_value_in_bit(:most, input, bit) do
    input
    |> Enum.map(&to_charlist/1)
    |> Enum.zip_reduce([], fn elements, acc -> [most_common_value(elements) | acc] end)
    |> Enum.reverse()
    |> Enum.at(bit)
  end

  defp common_value_in_bit(:less, input, bit) do
    input
    |> Enum.map(&to_charlist/1)
    |> Enum.zip_reduce([], fn elements, acc -> [less_common_value(elements) | acc] end)
    |> Enum.reverse()
    |> Enum.at(bit)
  end


  defp most_common_value(elements) do
    total = length(elements)
    ones = Enum.reduce(elements, 0, fn c, acc1 -> acc1 + c - ?0 end)

    cond do
      ones == total / 2 -> :equal
      ones > total / 2 -> "1"
      true -> "0"
    end
  end

  defp less_common_value(elements) do
    total = length(elements)
    ones = Enum.reduce(elements, 0, fn c, acc1 -> acc1 + c - ?0 end)

    cond do
      ones == total / 2 -> :equal
      ones > total / 2 -> "0"
      true -> "1"
    end
  end

  defp unwrap([val]), do: unwrap(val)
  defp unwrap(val), do: val
end
