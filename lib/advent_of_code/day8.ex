defmodule AdventOfCode.Day8 do

  @input_example """
rect 3x2
rotate column x=1 by 1
rotate row y=0 by 4
rotate column x=1 by 1
"""

  defmodule Field do
    defstruct height: 6, width: 50, marks: Keyword.new([])

    def apply_ops(%Field{} = field, []), do: field
    def apply_ops(%Field{} = field, [op|ops]) do
      op
      |> case do
        {:rect, x, y} ->
          marks = 0..(x-1)
          |> Enum.map(fn(x) ->
            0..(y-1)
            |> Enum.map(fn(y) ->
              {x, y}
            end)
          end)
          |> IO.inspect
          |> List.flatten
          |> IO.inspect
          |> unique_marks
          |> IO.inspect

          %Field{field|marks: marks}
          |> IO.inspect
          |> marks_to_columns
          |> IO.inspect

#          List.duplicate(nil, x)
#          |> List.duplicate(y)
#          |> IO.inspect
          field
        {:rotate_column, index, distance} ->
          # Convert to columns and shift
          field
        {:rotate_row, index, distance} ->
          # Convert to rows and shift
          field
      end
      |> apply_ops(ops)
    end

    def count_marks(%Field{marks: marks}) do
      length(marks)
    end

    defp unique_marks(marks) do
      marks
      |> Enum.sort
      |> Enum.uniq
    end

    defp marks_to_columns(%Field{height: h, width: w, marks: marks}) do
      cols = false
      |> List.duplicate(w)
      |> List.duplicate(h)

      Enum.reduce(marks, cols, fn({x, y}, acc) ->
        #IO.inspect {x, acc}
        List.replace_at(acc, x, List.replace_at(List.at))
        put_in(acc, [x, y], true)
      end)
      |> IO.inspect
    end
  end

  def solve() do
    ops = @input_example
    |> String.split("\n", trim: true)
    |> IO.inspect
    |> Enum.map(&to_op/1)
    |> IO.inspect

    count_marked = %Field{}
    |> Field.apply_ops(ops)
    |> Field.count_marks
  end

  defp to_op(<<"rect ", coords::bitstring>>) do
    [x, y] = coords
    |> String.split("x", trim: true)
    |> Enum.map(&String.to_integer/1)
    {:rect, x, y}
  end

  defp to_op(<<"rotate column x=", coords::bitstring>>) do
    [index, distance] = coords
    |> String.split(" by ", trim: true)
    |> Enum.map(&String.to_integer/1)
    {:rotate_column, index, distance}
  end

  defp to_op(<<"rotate row y=", coords::bitstring>>) do
    [index, distance] = coords
    |> String.split(" by ", trim: true)
    |> Enum.map(&String.to_integer/1)
    {:rotate_row, index, distance}
  end

end