defmodule Stats do

  require Integer
  
  @doc """
  returns the mean of a list of numbers

  ## Examples
     iex> Stats.mean([])
     0.0

     iex> Stats.mean([2])
     2.0

     iex> Stats.mean([7, 2, 9])
     6.0

     iex> Stats.mean([7, 2, 9, 5])
     5.75

  """

  @spec mean(list) :: float

  def mean([]) do
    0.0
  end

  def mean([num]) do
    num * 1.0
  end

  def mean(list) when Kernel.length(list) > 1 do
    n   = Kernel.length(list) * 1.0
    sum = List.foldl(list, 0, fn (x, acc) -> x + acc end)
    sum / n
  end

  @doc """
  returns the median of a list of numbers
  
  In practice, the median may be calculated as follows: 
  if there are n numeric data points, then by ordering the data values 
  (either non-decreasingly or non-increasingly),

  (a) the (n+1)/2-th data point is the median if n is odd, and
    
  (b) the midpoint of the (n -1)-th and the (n+1)-th data points is the median if n is even.

  ## Examples
     iex> Stats.median([26.1, 25.6, 25.7, 25.2, 25.0])
     25.6
     
     iex> Stats.median([24.7, 25.6, 25.0, 26.1,  25.7, 25.2])
     25.4

     iex> Stats.median([10.0])
     10.0

     iex> Stats.median([1, 3, 4, 9, 2, 6, 5, 8, 7])
     5

     iex> Stats.median([1, 3, 4, 9, 2, 10, 6, 5, 8, 7])
     5.5
  """

  def median([]) do
    0.0
  end

  def median(list) when Kernel.length(list) > 0 do
    n = Kernel.length(list)
    nlist = Enum.sort(list)
    cond do
      Integer.is_odd(n) ->
        elem_at(nlist, Kernel.div((n - 1), 2))
      true ->
        (elem_at(nlist, Kernel.div(n - 1, 2)) + elem_at(nlist, Kernel.div(n + 1, 2))) / 2.0
    end
  end
  
  @doc """
  returns the standard deviation of a list of numbers

  ## Examples
     iex> Stats.stdv([])
     :error

     iex> Stats.stdv([10])
     :error

     iex> Stats.stdv([7, 2, 9])
     3.60555127546398912486

     iex> Stats.stdv([7, 2, 9, 5])
     2.9860788111948193

  """

  def stdv([]) do
    :error
  end

  def stdv([num]) do
    :error
  end

  def stdv(list) do
    n = Kernel.length(list) * 1.0
    [sum, sum_squ] = List.foldl(list, [0, 0], fn (x, [s, sq]) -> [x + s, x * x + sq] end)
    :math.sqrt (n * sum_squ - sum * sum ) / (n * (n - 1))
  end

  # private helper functions

  defp elem_at([], _) do
    :error
  end

  defp elem_at(list, n) when n > Kernel.length(list) do    
    :error
  end
  
  defp elem_at(_, n) when n < 0 do
    :error
  end
  
  defp elem_at(list, 0) when Kernel.length(list) > 0 do
    List.first(list)    
  end

  defp elem_at([car | cdr], n) do
    if n == 0 do
      car
    else
      elem_at(cdr, n - 1)
    end
  end
  
end
