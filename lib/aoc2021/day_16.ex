defmodule Aoc2021.Day16 do
  use Aoc2021

  @type version :: integer()
  @type type :: integer()
  @type packet :: {version(), type(), packet() | [packet()]}

  def part1 do
    {packet, _rest} =
      load_packet()
      |> decode()

    sum_versions(packet, 0)
  end

  def part2 do
    {packet, _rest} =
      load_packet()
      |> decode()

    eval(packet)
  end

  defp eval(packets) when is_list(packets), do: Enum.map(packets, &eval/1)
  defp eval({_v, 0, values}), do: values |> eval() |> Enum.sum()
  defp eval({_v, 1, values}), do: values |> eval() |> Enum.product()
  defp eval({_v, 2, values}), do: values |> eval() |> Enum.min()
  defp eval({_v, 3, values}), do: values |> eval() |> Enum.max()
  defp eval({_v, 4, value}), do: value
  defp eval({_v, 5, [a, b]}), do: if(eval(a) > eval(b), do: 1, else: 0)
  defp eval({_v, 6, [a, b]}), do: if(eval(a) < eval(b), do: 1, else: 0)
  defp eval({_v, 7, [a, b]}), do: if(eval(a) == eval(b), do: 1, else: 0)

  defp sum_versions({v, _t, literal}, acc) when is_integer(literal),
    do: acc + v

  defp sum_versions({v, _t, subpackets}, acc) when is_list(subpackets),
    do: Enum.reduce(subpackets, acc + v, &sum_versions(&1, &2))

  defp decode(<<version::3, 4::3, rest::bitstring>>) do
    {value, rest} = decode_literal(rest)

    {{version, 4, value}, rest}
  end

  defp decode(<<ver::3, type::3, 0::1, len::15, data::bitstring-size(len), rest::bitstring>>) do
    {subpackets, <<>>} = decode_many(data)
    {{ver, type, subpackets}, rest}
  end

  defp decode(<<ver::3, type::3, 1::1, len::11, rest::bitstring>>) do
    {subpackets, rest} = decode_exact(rest, len)
    {{ver, type, subpackets}, rest}
  end

  defp decode_exact(data, n, acc \\ [])

  defp decode_exact(rest, 0, acc),
    do: {Enum.reverse(acc), rest}

  defp decode_exact(data, n, acc) do
    {value, rest} = decode(data)
    decode_exact(rest, n - 1, [value | acc])
  end

  defp decode_many(data, acc \\ [])

  defp decode_many(<<>>, acc),
    do: {Enum.reverse(acc), <<>>}

  defp decode_many(data, acc) do
    {value, rest} = decode(data)
    decode_many(rest, [value | acc])
  end

  defp decode_literal(data, acc \\ [])

  defp decode_literal(<<1::1, value::4, rest::bitstring>>, acc),
    do: decode_literal(rest, [value | acc])

  defp decode_literal(<<0::1, value::4, rest::bitstring>>, acc) do
    value =
      Enum.reverse([value | acc])
      |> Enum.map(&Integer.to_string(&1, 16))
      |> to_string()
      |> String.to_integer(16)

    {value, rest}
  end

  defp load_packet do
    fetch_input!(16)
    |> hd()
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.map(&String.to_integer(to_string(&1), 16))
    |> Enum.into(<<>>, fn v -> <<v::8>> end)
  end
end
