defmodule MyList do
  require MyEnum
  require Integer

  @doc """
  MyEnum.span(from, to, step) returns a list starting at from and ending at to with step step, the resulting list can be empty

  ## Examples
    iex > MyList.span(6, 20, 5)
    [6, 11, 16]

    iex > MyList.span(0, 20, 2)
    [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

    iex> MyList.span(1, 10)
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    iex> MyList.span(20, 0, 2)
    []

    iex> MyList.span(1, 2, 3)
    [1]

    iex> MyList.span(1, 1, 3)
    [1]

    MyList.span(1, 10, 0)
    []

    MyList.span(10, 0, -1)
    [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

    MyList.span(10, 0, -10)
    [10, 0]

    MyList.span(10, 0, -12)
    [10]

    MyList.span(-10, 10, 10)
    [-10, 0, 10]

    MyList.span(-10, 10, 11)
    [-10, 0]

    MyList.span(-10, 10, -11)
    []
  """

  def span(from, to, step \\ 1)

  def span(_, _, 0), do: []

  def span(from, to, step) when not(is_integer(from)) or not(is_integer(to)) or not(is_integer(step)) do
    []
  end

  def span(from, to, step) when from > to and step > 0 do
    []
  end

  def span(from, to, step) when from < 0 and to < 0 and step < 0  and from > to do
    []
  end

  def span(from, to, step) do
    _span([], from, from, to, step)
  end

  defp _span(lr, curr, _, to, step) when curr > to and step > 0 do
    MyEnum.reverse(lr)
  end

  defp _span(lr, curr, _, to, step) when curr < to and step < 0 do
    MyEnum.reverse(lr)
  end

  # MyList.span(10, 0, -12) ==> '\n' which is actually [ 10 ]
  defp _span(lr, curr, from, to, step) do
    _span([curr | lr], curr + step, from, to, step)
  end

  @doc """
  MyEnum.gen_prime(from, to) returns the list of prime between from and to
  
  ## Examples
    iex > MyList.gen_prime(50)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]

    iex > MyList.gen_prime(2, 50)
    [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
  
    MyList.gen_prime(2, 20)
    [2, 3, 5, 7, 11, 13, 17, 19]

    MyList.gen_prime(20, 0)  
    []

    MyList.gen_prime(-20, 0) 
    []

    MyList.gen_prime(-20, -10) 
    []
    
  """
  
  def gen_prime(from \\ 2, to) 
  
  def gen_prime(from, to) when not(is_integer(from)) or not(is_integer(to)) do
    []
  end
  
  def gen_prime(from, to) when from > to do
    []
  end
  
  def gen_prime(from, _) when from < 0 do  
    []
  end
  
  def gen_prime(0, to), do: gen_prime(2, to)    

  def gen_prime(1, to), do: gen_prime(2, to)    

  def gen_prime(from, to) when from == 2 do
    for x <- span(from + 1, to, 2), is_prime?(x), into: [from], do: x
  end

  def  gen_prime(from, to) when Integer.is_even(from) do
    for x <- span(from + 1, to, 2), is_prime?(x), into: [], do: x    
  end

  def  gen_prime(from, to) when Integer.is_odd(from) do
    for x <- span(from, to, 2), is_prime?(x), into: [], do: x    
  end
  
  defp is_prime?(x) do
    { limit, _ } = :math.sqrt(x)
    |> Float.floor
    |> Float.to_string
    |> Integer.parse    
    MyEnum.all? span(3, limit), &(rem(x, &1) != 0)  
  end
  
end
