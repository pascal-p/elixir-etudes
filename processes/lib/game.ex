defmodule Game do

  @suites [ "A", 2, 3, "J", "D" ]
  @families [ "Clubs", "Diamonds"]

  def init do
    card_deck = Cards.make_deck(@suites, @families)
    { card_set_A, card_set_B } = Enum.split(card_deck,
                                            Kernel.div(Kernel.length(card_deck), 2))
    # {[{2, "Diamonds"}, {"J", "Diamonds"}, {"A", "Diamonds"}, {"D", "Diamonds"}, {1, "Diamonds"}],
    #  [{2, "Clubs"}, {"J", "Clubs"}, {1, "Clubs"}, {"A", "Clubs"}, {"D", "Clubs"}]}
    #
    player_A = spawn(Players, :init, [card_set_A])
    player_B = spawn(Players, :init, [card_set_B])

    play([player_A, player_B], :pre, [], [], 0, [])
  end


  @doc """
  Arguments are:
    - list of player pids,
    - state of game,
    - cards received from player A,
    - cards received from player B,
    - number of players who have given cards, and
    - pile of cards for the battle (to compare)
  """


  @spec play(list, atom, list, list, integer, list) :: nil

  def play(player_list, state, cards_from_A, cards_from_B, num_rcvd, pile) do
    [player_A, player_B] = player_list
    case state do

      :pre ->
        case pile do
          [] ->
            IO.puts(" ==> Requesting 1 card from each player")
            request_cards(player_list, 1)
          _ ->
            IO.puts(" --> BATTLE! - Requesting 2 more cards from each player")
            request_cards(player_list, 2)
        end
        play(player_list, :wait, cards_from_A, cards_from_B, num_rcvd, pile)

      :wait when num_rcvd == 2 ->
        # both players sent their cards, we can now check them
        play(player_list, :check, cards_from_A, cards_from_B, 0, pile)

      :wait ->
        # waiting to receive all the cards, before moving to next state
        receive do
          {:here_cards, rcvd_cards, from_player} ->
            IO.puts(" <== Got #{inspect(rcvd_cards)} from #{inspect from_player}")
            cond do
              from_player == player_A ->
                play(player_list, state, rcvd_cards, cards_from_B, num_rcvd + 1, pile)

              from_player == player_B ->
                play(player_list, state, cards_from_A, rcvd_cards, num_rcvd + 1, pile)
            end
        end
        # then :wait with num_rcvd == 2, will match, for next state

      :check ->
        cond do
          Kernel.length(cards_from_A) == 0 and Kernel.length(cards_from_B) == 0 ->
            # won't happen, cards do not vanished, but convenient guard
            IO.puts(" >> DRAW")
            term_game(player_list)

          Kernel.length(cards_from_A) == 0 ->
            IO.puts(" >> player_B won")
            term_game(player_list)

          Kernel.length(cards_from_B) == 0 ->
            IO.puts(" >> player_A won")
            term_game(player_list)

          true ->
            # define winner for this turn or what to do next if card of equals values
            n_pile = eval_cards(player_list, cards_from_A, cards_from_B, pile)
            play(player_list, :pre, [], [], 0, n_pile) # next turn, we need cards...
        end
    end

  end

  @spec eval_cards(list, list, list, list) :: list

  # Evaluate the cards from both players.
  # If their values match, add them to the pile
  #  otherwise tell the winner to pick up the cards => pile is cleared.
  #
  # Wait for player to confirm he/she got the cards. Otherwise, because of asynchronism
  # a player with an empty hand might be asked to give a card before he/she collects the
  # won cards.
  #

  defp eval_cards(players, cards_from_A, cards_from_B, pile) do
    [player_A, player_B] = players
    # the last card (for comparison) is the hed of the card list
    [c_a, c_b] = [List.first(cards_from_A), List.first(cards_from_B)]
    v_a = Cards.card_value c_a
    v_b = Cards.card_value c_b
    n_pile = Enum.concat([pile, cards_from_A, cards_from_B])
    IO.puts(" ==> [CMP] card (A): #{inspect c_a} vs card (B): #{inspect c_b} // card pile: #{inspect(n_pile)}")
    #
    cond do
      v_a == v_b ->
        n_pile # prepare for a 'battle', need more cards

      v_a < v_b ->
        send(player_B, { :pick_up, n_pile, self }) # player_B won this turn,
        wait_until_picked_up
        []

      v_b < v_a ->
        send(player_A, { :pick_up, n_pile, self }) # player A won this battle
        wait_until_picked_up
        []
    end
  end

  defp request_cards(players, n_cards) do
    Enum.each(players,
      fn(pid) -> send(pid, { :send_cards, n_cards, self }) end)
  end

  defp wait_until_picked_up do
    # wait for specific message such as :got_cards, from player (A or B)
    receive do
      { :got_cards, player } ->
        IO.puts(" ==> Player #{inspect player} picked up the cards")
        player
    end
  end

  defp term_game(players) do
    Enum.each(players,
      fn(pid) -> send(pid, :exit) end)
  end

end
