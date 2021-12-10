defmodule Aoc2021.Day4 do
  use Aoc2021

  def part1 do
    input = fetch_input!(4)

    {numbers, input} = parse_numbers(input)
    boards = parse_boards(input)

    {last_num, board} = play_bingo_first_win(boards, numbers)

    board
    |> List.flatten()
    |> Enum.reject(&(&1 == :ok))
    |> Enum.reduce(fn n, acc -> acc + n end)
    |> Kernel.*(last_num)
  end

  def part2 do
    input = fetch_input!(4)

    {numbers, input} = parse_numbers(input)
    boards = parse_boards(input)

    {last_num, board} = play_bingo_last_win(boards, numbers)
    board
    |> List.flatten()
    |> Enum.reject(&(&1 == :ok))
    |> Enum.reduce(fn n, acc -> acc + n end)
    |> Kernel.*(last_num)
  end

  defp play_bingo_last_win(boards, numbers) do
    {_boards, winners} =
      Enum.reduce_while(numbers, {boards, []}, fn number, {boards1, winners} ->
        boards1 = boards_mark_number(boards1, number)

        boards1
        |> Enum.with_index(1)
        |> Enum.reduce([], fn {board, index}, cur_winners ->
          if winner_board?(board) do
            [{number, index, board} | cur_winners]
          else
            cur_winners
          end
        end)
        |> case do
          [] ->
            {:cont, {boards1, winners}}

          winner_boards ->
            {:cont, {boards1, winner_boards ++ winners}}
        end
      end)

    {last_number, _index, board} =
      winners
      |> Enum.reverse()
      |> Enum.uniq_by(&elem(&1, 1))
      |> List.last()

    {last_number, board}
  end

  defp play_bingo_first_win(boards, numbers) do
    Enum.reduce_while(numbers, boards, fn number, boards1 ->
      boards1 = boards_mark_number(boards1, number)

      boards1
      |> Enum.with_index(0)
      |> Enum.reverse()
      |> Enum.reduce(:none, fn {board, index}, last_winner ->
        if winner_board?(board) do
          index
        else
          last_winner
        end
      end)
      |> case do
        winner_board when is_integer(winner_board) ->
          {:halt, {number, Enum.at(boards1, winner_board)}}

        :none ->
          {:cont, boards1}
      end
    end)
  end

  defp parse_numbers(input) do
    [numbers, "" | rest] = input
    numbers = numbers |> String.split(",") |> Enum.map(&String.to_integer/1)

    {numbers, rest}
  end

  defp parse_boards(input, acc \\ []) do
    case Enum.split(input, 6) do
      {[], _rest} ->
        Enum.reverse(acc)

      {rows, rest} ->
        board =
          rows
          |> Enum.take(5)
          |> Enum.map(fn row ->
            row
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)
          end)

        parse_boards(rest, [board | acc])
    end
  end

  defp boards_mark_number(boards, number) do
    for board <- boards do
      for row <- board do
        for n <- row do
          if n == number do
            :ok
          else
            n
          end
        end
      end
    end
  end

  defp winner_board?(board) do
    Enum.any?(board, &winner_row?/1) || Enum.any?(transpose(board), &winner_row?/1)
  end

  defp winner_row?(row) do
    Enum.all?(row, &(&1 == :ok))
  end

  defp transpose([
         [r11, r12, r13, r14, r15],
         [r21, r22, r23, r24, r25],
         [r31, r32, r33, r34, r35],
         [r41, r42, r43, r44, r45],
         [r51, r52, r53, r54, r55]
       ]) do
    [
      [r11, r21, r31, r41, r51],
      [r12, r22, r32, r42, r52],
      [r13, r23, r33, r43, r53],
      [r14, r24, r34, r44, r54],
      [r15, r25, r35, r45, r55]
    ]
  end
end
