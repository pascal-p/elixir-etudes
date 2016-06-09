defmodule MyENumTest do
  use ExUnit.Case
  doctest MyEnum
  import Expect
  require Integer

  ## MyEnum.all?
  expect "all? true" do
    res = MyEnum.all?([2, 4, 6, 8], &Integer.is_even/1)
    assert res
  end

  expect "all? false, because not all are even" do
    res = MyEnum.all?([1, 2, 3, 4, 6, 8], &Integer.is_even/1)
    assert !res
  end

  expect "all? false, because not all are < 4" do
    res = MyEnum.all?([1, 2, 3, 4, 6, 8], &(&1 < 4))
    assert !res
  end

  ## MyEnum.any?
  expect "any? true" do
    res = MyEnum.any?([2, 4, 6, 8], &Integer.is_even/1)
    assert res
  end

  expect "any? false" do
    res = MyEnum.any?([1, 3, 5, 7], &Integer.is_even/1)
    assert !res
  end

  expect "any? true, because some are less than 4" do
    res = MyEnum.any?([1, 2, 3, 4, 6, 8], &(&1 < 4))
    assert res
  end

  ## MyEnum.filter
  expect "filter even" do
    res = MyEnum.filter([1, 2, 3, 4, 6, 8], &Integer.is_even/1)
    assert res == [2, 4, 6, 8]
  end

  expect "filter odd" do
    res = MyEnum.filter([1, 2, 3, 4, 6, 8], &Integer.is_odd/1)
    assert res == [1, 3]
  end

  ## MyEnum.split
  expect "split by 4" do
    res = MyEnum.split([1, 2, 3, 4, 6, 8, 9, 11, 12], 4)
    assert res == [[1, 2, 3, 4], [6, 8, 9, 11], [12]]
  end

  expect "split none" do
    res = MyEnum.split([1, 2, 3, 4, 6, 8, 9, 11, 12], -2)
    assert res == []
  end

  ## MyEnum.flatten


  ## MyEnum.take


end
