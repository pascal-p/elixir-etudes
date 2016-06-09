defmodule Dates do

  @days_per_month [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  
  @doc """
  Calculate the julian date given a date in ISO format ("yyyy-mm-dd")

  ## Examples
     iex> Dates.julian("2013-12-31")
     365

     iex> Dates.julian("2012-12-31")
     366

     iex> Dates.julian("2012-02-05")
     36

     iex> Dates.julian("2013-02-05")
     36

     iex> Dates.julian("1900-03-01")
     60

     iex> Dates.julian("2000-03-01")
     61

     iex> Dates.julian("2013-01-01")
     1

  """

  def julian(date) do
    [{y, _}, {m, _}, {d, _}] = String.split(date, "-") |> Enum.map(&Integer.parse/1)
    m_dur = month_day_tot(m, d)
    if is_leap_year?(y) and m > 2 do
      m_dur = m_dur + 1
    end
    m_dur
  end

  defp month_day_tot(m, d) do
    {list, _ } = Enum.split(@days_per_month, m - 1)
    List.foldl(list, d, fn (mdur, mtot) -> mtot + mdur end)
  end  
  
  defp is_leap_year?(y) do
    (rem(y, 4) == 0 and rem(y, 100) != 0) or (rem(y, 400) == 0)
  end

end
