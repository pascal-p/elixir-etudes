defmodule Calculus do

  @delta 1.0e-10

  @doc """
  Calculate the rate of changes of a given mathematical  function.

  ## Examples
     iex> Calculus.derivative(fn(x) -> x * x end, 3)
     6.00000049644222599454

     iex> Calculus.derivative(fn(x) -> 3 * x * x + 2 * x + 1 end, 5)
     32.00000264769187197089

     iex> Calculus.derivative(&:math.sin/1, 0)
     1.0  
  """

  def derivative(fun, x \\ 0.0) do
    (fun.(x + @delta) - fun.(x)) / @delta
  end
  
end
