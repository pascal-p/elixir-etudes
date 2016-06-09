defmodule MyListTest do
  use ExUnit.Case
  doctest MyList
  import Expect
  require Integer
  require MyEnum

  # TODO

  # [ '\n' ] is [ 10 ] 
  expect "span(10, 0, -12) => singleton" do
    res = MyList.span(10, 0, -12)
    assert res == [10]
  end


  expect "prime " do
    res = MyList.gen_prime(0, 100)
    assert res ==  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73,
                    79, 83, 89, 97]
  end
end
