defmodule AdventOfCode do

  def day1() do
    solution = AdventOfCode.Day1.solve
    IO.puts("Solution: #{inspect solution}")
  end

  def day2() do
    solution = AdventOfCode.Day2.solve(:default)
    IO.puts("Solution default: #{inspect solution}")
    solution = AdventOfCode.Day2.solve(:complex)
    IO.puts("Solution complex: #{inspect solution}")
  end

  def day3() do
    solution = AdventOfCode.Day3.solve(:horizontal)
    IO.puts("Solution: #{inspect solution}")
    solution = AdventOfCode.Day3.solve(:vertical)
    IO.puts("Solution: #{inspect solution}")
  end

#  def day4() do
#    solution = AdventOfCode.Day4.solve()
#    IO.puts("Solution: #{inspect solution}")
#    solution = AdventOfCode.Day4.decifer()
#    IO.puts("Solution: #{inspect solution}")
#  end

  def day5() do
    solution = AdventOfCode.Day5.solve()
    IO.puts("Solution: #{inspect solution}")
    solution = AdventOfCode.Day5.solve2()
    IO.puts("Solution: #{inspect solution}")
  end

end
