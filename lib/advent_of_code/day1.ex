defmodule AdventOfCode.Day1 do

  @input "R5, L2, L1, R1, R3, R3, L3, R3, R4, L2, R4, L4, R4, R3, L2, L1, L1, R2, R4, R4, L4, R3, L2, R1, L4, R1, R3, L5, L4, L5, R3, L3, L1, L1, R4, R2, R2, L1, L4, R191, R5, L2, R46, R3, L1, R74, L2, R2, R187, R3, R4, R1, L4, L4, L2, R4, L5, R4, R3, L2, L1, R3, R3, R3, R1, R1, L4, R4, R1, R5, R2, R1, R3, L4, L2, L2, R1, L3, R1, R3, L5, L3, R5, R3, R4, L1, R3, R2, R1, R2, L4, L1, L1, R3, L3, R4, L2, L4, L5, L5, L4, R2, R5, L4, R4, L2, R3, L4, L3, L5, R5, L4, L2, R3, R5, R5, L1, L4, R3, L1, R2, L5, L1, R4, L1, R5, R1, L4, L4, L4, R4, R3, L5, R1, L3, R4, R3, L2, L1, R1, R2, R2, R2, L1, L1, L2, L5, L3, L1"

  def solve() do
    @input
    |> parse
    |> walk
    |> solve
  end

  defp parse(string) do
    string
    |> String.split(",")
    |> Enum.map(fn(char_number) ->
      char_number
      |> String.trim
      |> parse_char_number
    end)
  end

  defp walk(directions) do
    directions
    |> Enum.reduce({:north, 0, 0, []}, fn({dir, distance}, {compass, x, y, history}) ->
      {new_dir, new_x, new_y} = case {compass, dir} do
        {:north, :right} -> {:east, x + distance, y}
        {:north, :left}  -> {:west, x - distance, y}

        {:east, :right}  -> {:south, x, y - distance}
        {:east, :left}   -> {:north, x, y + distance}

        {:south, :right} -> {:west, x - distance, y}
        {:south, :left}  -> {:east, x + distance, y}

        {:west, :right}  -> {:north, x, y + distance}
        {:west, :left}   -> {:south, x, y - distance}
      end
      {new_dir, new_x, new_y, [{{:from, x, y}, {:to, new_x, new_y}} | history]}
    end)
  end

  defp solve({_dir, x, y, history}) do
    history_distance = history
    |> visited_places
    |> first_duplicate
    |> distance

    {distance({x, y}), history_distance}
  end

  defp distance({x, y}) do
    abs(x) + abs(y)
  end

  defp parse_char_number(<<dir, number::binary>>) do
    {
      dir |> dir_to_atom,
      number |> String.to_integer
    }
  end

  defp dir_to_atom(?R), do: :right
  defp dir_to_atom(?L), do: :left

  defp visited_places(history) do
    history
    |> Enum.reverse
    |> Enum.flat_map(fn({{:from, from_x, from_y}, {:to, to_x, to_y}}) ->
      cond do
        from_x == to_x ->
          Range.new(from_y, to_y) |> Enum.reverse |> Enum.drop(1) |> Enum.reverse |> Enum.map(&({from_x, &1}))
        from_y == to_y ->
          Range.new(from_x, to_x) |> Enum.reverse |> Enum.drop(1) |> Enum.reverse |> Enum.map(&({&1, from_y}))
      end
    end)
  end

  defp first_duplicate(places) do
    first_duplicate(places, [])
  end
  defp first_duplicate([place|places], visited) do
    cond do
      place in visited ->
        place
      true ->
        first_duplicate(places, [place|visited])
    end
  end
  defp first_duplicate([], _), do: nil

end