defmodule Cards do

  @suites [ "A", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "D", "K" ]
  @families [ "Clubs", "Diamonds", "Hearts", "Spades" ]

  def make_deck do
    for x <- @suites, y <- @families do
      {x, y} 
    end
  end

  #
  # init. the random seed
  #
  def shuffle(list) do
    :random.seed(:erlang.now())
    shuffle(list, [])
  end

  defp shuffle([], acc) do
    acc
  end

  #
  # partition initial list into 2 sub-lists: leading and [h | t]
  # the number of elements in leading(list) is defined by a call to :random.uniform
  # :random.uniform return a integer between [0, number_of_element_in(list)]
  # the :random.uniform(Enum.count(list)) - 1) ensures that [h | t] contains at least
  # 1 element
  #
  defp shuffle(list, acc) do
    {leading, [h | t]} = Enum.split(list, :random.uniform(Enum.count(list)) - 1)
    shuffle(leading ++ t, [h | acc])
  end

end
