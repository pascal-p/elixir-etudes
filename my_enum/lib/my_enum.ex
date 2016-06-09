defmodule MyEnum do
  # require MyMacros

  @doc """
  MyEnum.all?(list, pred) returns true if pred is true for all element in list, false otherwise

  ## Examples
    iex> MyEnum.all? [1, 2, 3, 4, 5], &(&1 > 0)
    true

    iex> MyEnum.all? [1, 2, 3], &(&1 < 3)
    false

    iex> MyEnum.all?(["Abracadabra", "Tumetai", "nokogiri" ], &(String.length(&1) > 3))
    true
  """

  def all?([], _), do: true

  def all?([h | t], pred), do: pred.(h) && all?(t, pred)

  @doc """
  MyEnum.any?(list, pred) returns false if pred is false for every element of list and true otherwise

  ## Examples
    iex> MyEnum.any? [1, 2, 3, 4, 5], &(&1 > 0)
    true

    iex> MyEnum.any? [1, 2, 3], &(&1 > 4)
    false

    iex> MyEnum.any?(["Abracadabra", "Tumetai", "nokogiri" ], &(String.length(&1) > 3))
    true
  """

  def any?([], _), do: false

  def any?([h | t], pred), do: pred.(h) || all?(t, pred)

  @doc """
  MyEnum.filter(list, filt) returns a list of elem satisfying filt

  ## Examples
    iex> MyEnum.filter [1, 2, 3, 4, 5], &(&1 > 0)
    [1, 2, 3, 4, 5]

    iex> MyEnum.filter [1, 2, 3, 4, 5], &(&1 < 0)
    []

    iex> MyEnum.filter [1, 2, 3, 4, 5], &(&1 == 10)
    []

    iex> MyEnum.filter [], &(&1 >= 0)
    []

    iex> MyEnum.filter [1, 2, 3, 4, 5], fn _ -> true end
    [1, 2, 3, 4, 5]
  """

  def filter(list, filt), do: _filter(list, [], filt)

  defp _filter(list, lr, filt, way \\ :in)

  defp _filter([], lr, _, _), do: lr

  # NO, it won't work, how do we generate functions iff they are  not already generated
  # defp _filter(list, lr, filt, way) do
  #   MyMacros.gen_defp("_filter_#{way}", func, if kw == :in, do: "" else: "not")
  #   case way do
  #     :in ->  _filter_in(list, lr, filt)
  #     :out ->  _filter_out(list, lr, filt)
  #   end
  # end

  defp _filter([h | t], lr, filt, way) do
    case way do
      :in -> _filter_in([h | t], lr, filt)
      :out -> _filter_out([h | t], lr, filt)
    end
  end

  def _filter_in([], lr, _),  do: reverse(lr)

  def _filter_in([h | t], lr, filt) do
    case filt.(h) do
      val when val in [false, nil] -> _filter_in(t, lr, filt)
      _ -> _filter_in(t, [h | lr], filt)
    end
  end

  def _filter_out([], lr, _),  do: reverse(lr)

  def _filter_out([h | t], lr, filt) do
    case !filt.(h) do
      val when val in [false, nil] -> _filter_out(t, lr, filt)
      _ -> _filter_out(t, [h | lr], filt)
    end
  end

  # defp _filter([h | t], lr, filt, way) do
  #   bool = MyMacros.on(way, :in, filt.(h))
  #   case bool do
  #     val when val in [false, nil] -> _filter(t, lr, filt, way)
  #     _ -> _filter(t, [h | lr], filt, way) # truthy
  #   end
  # end

  @doc """
  MyEnum.reject(list, filt) returns a list of elem that do not satisfied filt (the converse of MyEnum.filter)

  ## Examples
    iex> MyEnum.reject [1, 2, 3, 4, 5], &(&1 > 0)
    []

    iex> MyEnum.reject [1, -2, 3, -4, 5], &(&1 < 0)
    [1, 3, 5]

    MyEnum.reject [1, 2, 3, 4, 5], fn _ -> false end
    []

    iex> MyEnum.reject [1, 2, 3, 4, 5], &(&1 == 10)
    [1, 2, 3, 4, 5]
  """

  def reject(list, filt), do: _filter(list, [], filt, :out)

  @doc """
  MyEnum.split(list, n), returns a list of lists whose length are <= n

  ## Examples
    iex> MyEnum.split([1, 2, 3, 4, 5], 3)
    [[1, 2, 3], [4, 5]]

    iex> MyEnum.split([], 3)
    []

    iex> MyEnum.split([1, 2, 3, 4, 5], -2)
    []

    iex> MyEnum.split([1, 2, 3, 4], 5)
    [[1, 2, 3, 4]]

  """

  def split(list, n), do: _split(list, [[]], n)

  defp _split([], _, n) when n < 0 do
    []
  end

  defp _split([], lr, _) do
    if lr == [[]] do
      []
    else
      reverse(lr, true)
    end
  end

  defp _split([h | t], [h1 | t1], n) do
    if (Kernel.length(h1) + 1) <= n do
      _split(t, [ [h | h1] | t1], n)
    else
      _split(t, [[h] | [h1 | t1]], n)
    end
  end

  # TODO: each

  @doc """
  MyEnum.take(list, n) takes the first n element of list

  ## Examples
     iex> MyEnum.take([], 3)
     []

     iex> MyEnum.take([1, 2], 3)
     []

     iex> MyEnum.take([], 3)
     []

     iex> MyEnum.take([1, 2, 3, 4, 5, 6], 3)
     [1, 2, 3]

     iex> MyEnum.take([2, 4, 6, 8], 4)
     [2, 4, 6, 8]

     iex> MyEnum.take([0, 2, 4, 6, 8, 10], 4)
     [0, 2, 4, 6]

     iex> MyEnum.take([0, 2, 4, 6, 8, 10], -4)
     []

     iex> MyEnum.take([0, 2, 4, 6, 8, 10], 0)
     []

     iex> MyEnum.take([0, 2, 4, 6, 8, 10], 1)
     [0]

  """

  def take(list, n), do: _take(list, [], n, 0)

  defp _take(_, _, n, _) when n < 0 do
    []
  end

  defp _take(_, lr, n, n), do: reverse(lr)

  defp _take([], _, n, m) when m < n do
    []
  end

  defp _take([h | t], lr, n, m), do: _take(t, [h | lr], n, m + 1)

  @doc """
  MyEnum.flatten(list), returns a one level list by flattening all nested lists from original list

  ## Examples
     iex> MyEnum.flatten([[1, 2], [3, [4, 6], 5]])
     [1, 2, 3, 4, 6, 5]

     iex> MyEnum.flatten([[1, 2], [3, 5]])
     [1, 2, 3, 5]

     iex> MyEnum.flatten([2, 1, 3, 5])
     [2, 1, 3, 5]

     iex> MyEnum.flatten([[1, 2], [3, 5]])
     [1, 2, 3, 5]

     iex> MyEnum.flatten([])
     []

     iex> MyEnum.flatten([[[[]]]])
     []

     iex> MyEnum.flatten([1, [2, [3, [5, [4, [6]], 8], 7], 9], 10])
     [1, 2, 3, 5, 4, 6, 8, 7, 9, 10]

  """
  def flatten(list), do: _flatten(list, [])

  defp _flatten([], lr), do: reverse(lr)

  defp _flatten([h | t], lr) do
    if is_list(h) do
      _flatten(t, reverse(_flatten(h, lr)))
    else
      _flatten(t, [h | lr])
    end
  end

  @doc """
  MyEnum.reverse(list) returns a list for which each element (at first level) are in reverse order (from the original list)

  ## Examples
    iex> MyEnum.reverse [1, 2, 3, 4, 5]
    [5, 4, 3, 2, 1]

    iex> MyEnum.reverse [[1, 2], [3, 4], [5]]
    [[5], [3, 4], [1, 2]]

    iex> MyEnum.reverse([[1, 2], [3, 4], [5]], true)
    [[5], [4, 3], [2, 1]]

    iex> MyEnum.reverse([[1, 2], [3, 4], 5, [6, 7]], true)
    [[7, 6], 5, [4, 3], [2, 1]]

    iex> MyEnum.reverse [1]
    [1]

    iex> MyEnum.reverse []
    []

  """

  def reverse(list, nested \\ false)

  def reverse(list, nested), do: _reverse(list, nested, [])

  defp _reverse([], _, lr), do: lr

  defp _reverse([h | t], nested, lr) do
    case nested do
      true ->
        if is_list(h) do
          _reverse(t, nested, [_reverse(h, nested, []) | lr])
        else
          _reverse(t, nested, [h | lr])
        end
      false -> _reverse(t, nested, [h | lr])
    end
  end
  
end
