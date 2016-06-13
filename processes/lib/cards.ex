defmodule Cards do

  require Inspect
  
  @suites [ "A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "D", "K" ]
  @families [ "Clubs", "Diamonds", "Hearts", "Spades" ]

  def make_deck(suites \\ @suites, families \\ @families) do
    deck = for x <- suites, y <- families do
      {x, y}
    end
    shuffle deck
  end

  # a card is a tuple, ex. {"A", "Clubs"}
  def card_value({val, _}) do
    case val do
      "J" -> 11
      "D" -> 12
      "K" -> 13
      "A" -> 14
      _ -> val
    end
  end

  #
  # init. the random seed
  #
  defp shuffle(list) do
    :random.seed(:erlang.timestamp) # :erlang.now())
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

  
  defimpl Inspect, for: Cards do
    def inspect({value, family}, _opts) do
      # {value, family} = card
      "#{value}/#{family}"
    end
  end
  
end
