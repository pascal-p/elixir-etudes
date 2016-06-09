defmodule Utils do

  @factor 1_000
  
  def round(val), do: Kernel.round(val * 100.0) / 100.0
  
  def num_to_str(num) do
    Enum.join(num_to_list(num, []), "_")
  end
   
  defp num_to_list(num, list \\ []) do
    cond do
      num == 0 ->
        list
      num < @factor ->
        [ "#{num}" | list ]
      true ->
        rest = Kernel.rem(num, @factor)
        str = comp(rest)
        num_to_list(Kernel.div(num, @factor), ["#{str}" | list])
    end
  end
  
  defp comp(rest) do
    cond do
      rest < 10
        -> "00#{rest}"
      rest < 100
        -> "0#{rest}"
      true ->
        "#{rest}"
    end
  end
  
end
