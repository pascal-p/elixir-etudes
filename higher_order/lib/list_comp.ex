defmodule ListComp do

  # private function to return a list of people
  @spec get_people() :: list(tuple())

  defp get_people() do
    [{"Federico", "M", 22}, {"Kim", "F", 45}, {"Hansa", "F", 30},
     {"Tran", "M", 47}, {"Cathy", "F", 32}, {"Elias", "M", 50}]
  end


  @doc """
  using pattern matching on a list of tuples to extract male over 40 (logical and)

  ## Examples
     iex> ListComp.extract_male_over_40
     [{"Elias", "M", 50}, {"Tran", "M", 47}]

  """

  def extract_male_over_40(list \\ get_people()) do
    extract_male_over_40(list, [])
  end

  @doc """
  using pattern matching on a list of tuples to extract male or over 40.

  ## Examples
     iex>  ListComp.extract_male_or_over_40
     [{"Elias", "M", 50}, {"Tran", "M", 47}, {"Kim", "F", 45}, {"Federico", "M", 22}]

  """

  def extract_male_or_over_40(list \\ get_people) do
    extract_male_or_over_40(list, [])
  end

  @doc """
  using list comprehension and pattern matching on a list of tuples to extract male over
  40 (logical and)

  ## Examples
     iex> ListComp.extract_male_over_40_lc
     [{"Tran", "M", 47}, {"Elias", "M", 50}]

  """

  def extract_male_over_40_lc(list \\ get_people()) do
    for {name, sex, age} <- list, sex == "M", age > 40 do
      {name, sex, age}
    end
  end

  @doc """
  using list comprehension and pattern matching on a list of tuples to extract male or over 40.

  ## Examples
     iex>  ListComp.extract_male_or_over_40_lc
     [{"Federico", "M", 22}, {"Kim", "F", 45}, {"Tran", "M", 47}, {"Elias", "M", 50}]

  """

  def extract_male_or_over_40_lc(list \\ get_people) do
    for {name, sex, age} <- list, sex == "M" or age > 40 do
      {name, sex, age}
    end
  end

  # private helper functions

  defp extract_male_over_40([], rl), do: rl

  defp extract_male_over_40([ {name, sex, age} | cdr ], rl) when sex == "M" and age > 40 do
    extract_male_over_40(cdr, [ {name, sex, age} | rl ])
  end

  defp extract_male_over_40([ _ | cdr ], rl) do
    extract_male_over_40(cdr, rl)
  end

  defp extract_male_or_over_40([], rl), do: rl

  defp extract_male_or_over_40([ {name, sex, age} | cdr ], rl) when sex == "M" or age > 40 do
    extract_male_or_over_40(cdr, [ {name, sex, age} | rl ])
  end

  defp extract_male_or_over_40([ _ | cdr ], rl) do
    extract_male_or_over_40(cdr, rl)
  end

end
