defmodule AdventOfCode.Day5 do

  @input_example "abc" #
                 #abc3231929

  @input "abbhdwsy"

  @chunk_size 100_000
  @cores 4

  def solve() do
    @input
    |> find_password_parallel
    |> IO.inspect
  end

  defp find_password_parallel(input) do
    # Create a source for a stream of numbers
    Stream.iterate(0, &(&1+1))
    |> Stream.chunk(@chunk_size)
    |> Stream.chunk(@cores)
    |> Stream.map(fn(chunks) ->
      chunks
      |> Enum.map(fn(numbers) ->
        Task.async(fn ->
          numbers
          |> Enum.flat_map(fn(number) ->
            "#{input}#{number}"
            |> md5
            |> hash_prefix(number)
            |> case do
              {:ok, {number, char}} -> [{number, char}]
              :error -> []
            end
          end)
        end)
      end)
      |> Enum.map(&Task.await/1)
      |> List.flatten
    end)
    |> Stream.flat_map(fn(x) -> x end)
    |> Enum.take(8)
    |> Enum.sort(fn({number1, _char1}, {number2, _char2}) ->
      number1 < number2
    end)
    |> Enum.map(fn({_number, char}) ->
      char
    end)
    |> Enum.join
  end

#  defp find_password(_input, _i, password_chars) when length(password_chars) == 8, do: password_chars |> Enum.reverse |> Enum.join
#  defp find_password(input, i, password_chars) do
#    "#{input}#{i}"
#    |> md5
#    |> hash_prefix(i)
#    |> case do
#      {:ok, {_number, char}} ->
#        find_password(input, i+1, [char|password_chars])
#      :error ->
#        find_password(input, i+1, password_chars)
#    end
#  end

  defp md5(string) do
    :crypto.hash(:md5, string) |> Base.encode16(case: :lower)
  end

  defp hash_prefix(<<"00000", char::bitstring-8, _::binary>>, number), do: {:ok, {number, char}}
  defp hash_prefix(<<_::binary>>, _number), do: :error

end