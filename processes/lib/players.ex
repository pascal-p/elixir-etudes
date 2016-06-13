defmodule Players do

  def init(hand) do
    IO.puts(" [#{__MODULE__}] ====>> player #{inspect self} starting with hand #{inspect hand}...")
    # any other init. would go here...
    play(hand)
  end

  def play(hand) do
    receive do
      { :send_cards, num, from } ->
        {cards_to_send, new_hand} = Enum.split(hand, num) # prep the cards
        send(from, {:here_cards, cards_to_send, self})    # then send message :got_cards
        play(new_hand)                                    # loop to process next message

      { :pick_up, rcv_cards, from } ->
        new_hand = Enum.concat([hand, rcv_cards]) # add this to current hand
        IO.puts " [#{__MODULE__}] ====>> player #{inspect self} won #{inspect rcv_cards}"
        send(from, {:got_cards, self})            # then send message :got_cards
        play(new_hand)                            # loop to process next message

      { :exit } ->
        IO.puts(" [#{__MODULE__}] ++++>> player #{inspect self} exiting the game...")
        exit(:exit)
    end
  end

end
