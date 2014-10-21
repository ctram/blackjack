# blackjack.rb

## Methods ##########################################################

# Returns boolean
def player_busts?(hand, cards_n_values, player, initial_deal_bool)
  if sum_cards(hand, cards_n_values, player, initial_deal_bool) > 21
    return true
  else
    return false
  end
end

# Determine which player is the winner -- returns users_name, "push", or "Dealer"
def who_is_winner?(users_name, users_hand, dealers_hand, cards_n_values, initial_deal_bool)
  # Set variables to make it easier on the eyes in proceeding decision tree
  users_sum = sum_cards(users_hand, cards_n_values, users_name, initial_deal_bool)
  dealers_sum = sum_cards(dealers_hand, cards_n_values, "Dealer", initial_deal_bool)

  if users_sum > dealers_sum
    # User wins
    return users_name
  elsif users_sum == dealers_sum
    # Push, no one wins, game over
    return "push"
  else
    # Dealer wins
    return "Dealer"
  end

end

# Return sum fixnum
def sum_cards(hand, cards_n_values, player, initial_deal_bool)
  sum = 0
  num_of_aces = 0

  if player == "Dealer" and initial_deal_bool == true
    # Only sum the Dealer's faceup card
    card = hand[0]
    card = card.split("_")[1]     # card is a string with suit and number. Remove suit (delimiter "_") and only use the number.

    # Keep track of how many Aces are in the hand
    if card == 11
      num_of_aces += 1
    end

    sum += cards_n_values[card] # cards_n_values is hash of card numbers and values

  else

    # Hand sum calculation for all other hands that do not involve a card facedown.
    hand.each_with_index do |card, i|
      card = card.split("_")[1]   # card is a string with suit and number. Remove suit (delimiter "_") and only use the number.

      # Keep track of how many Aces are in the hand.
      if cards_n_values[card] == 11
        num_of_aces += 1
      end

      sum += cards_n_values[card]
    end

  end

  # If sum is over 21 and there is an Ace, give the Ace a value of one.
  while sum > 21 and num_of_aces > 0
    sum = sum - 11 + 1
    num_of_aces -= 1
  end

  sum
end

# Returns new hand and deck_final
def deal_a_card(players_hand, deck_final)
    players_hand << deck_final.pop
    return players_hand, deck_final
end

def display_players_hand(player, players_hand, initial_deal_bool, cards_n_values)
  puts "#{player}'s cards: \n"

  # If player is dealer and this is the initial deal, do NOT show the second card, casino style
  if initial_deal_bool == true and player == "Dealer"

    players_hand.each_with_index do |card, i|
      if i == players_hand.length - 1   # Do not show Dealer's second card.
        print "Face_Down,"
      else
        print card + ", "
      end
    end

  else

    players_hand.each_with_index do |card, i|
      print card + ", "
    end

  end

  puts
  puts "Sum of #{player}'s hand: " + sum_cards(players_hand, cards_n_values, player, initial_deal_bool).to_s
  puts
end

# TODO: method to display both hands
def display_both_hands(users_name, dealers_hand, users_hand, initial_deal_bool, cards_n_values)
  display_players_hand("Dealer", dealers_hand, initial_deal_bool, cards_n_values)
  puts
  display_players_hand(users_name, users_hand, false, cards_n_values)
  puts

  return nil
end

## Setup variables ######################################################
user_wants_to_continue = true

suits = %w(Diamond Spade Club Heart)

values = [11,2,3,4,5,6,7,8,9,10,10,10,10]           # Card values
keys = %w( Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)  # Card names

cards_n_values = {}

keys.each_with_index do |k,i|
  cards_n_values[k] = values[i]   # Associate names with values in a hash
end

deck_base = []

# Generate a single deck
suits.each_with_index do |suit, i|
  cards_n_values.each do |k,v|
    deck_base << suit + "_"+ k
  end
end

num_of_decks_to_use = 2   # Change how many decks to use in the game
deck_final = []

# Generate final deck based on number of desks to use in game
(1..num_of_decks_to_use).each do |x|
    deck_base.each_with_index do |e,i|
        deck_final << e
    end
end

## Start Output to Screen ##############################################
system 'clear'
puts "Welcome to Blackjack!"
puts "What's your name?"
print ">> "
users_name = gets.chomp.capitalize
puts
system 'clear'
puts "Alright, #{users_name}, let's play some Blackjack...\n\n"

begin
  deck_final.shuffle!

  users_hand = []
  dealers_hand = []

  # Initial deal, deal 2 cards to each player
  (1..2).each do |x|
    users_hand, deck_final = deal_a_card(users_hand, deck_final)
    dealers_hand, deck_final = deal_a_card(dealers_hand, deck_final)
  end

  begin
    # Display Dealer and User's cards
    # Do not show Dealer's second card if this is the first deal

    display_both_hands(users_name, dealers_hand, users_hand, true, cards_n_values)

    user_stays = false
    user_busts = false

    acceptable_input = %w(s h)
    input = nil

    until acceptable_input.include?(input)
      puts "Stay or hit? (\"s\" or \"h\")"
      input = gets.chomp.downcase
    end

    if input == "s"
      user_stays = true
    else
      users_hand, deck_final = deal_a_card(users_hand, deck_final)
      system 'clear'
    end

    if player_busts?(users_hand, cards_n_values, users_name, false) == true
      display_both_hands(users_name, dealers_hand, users_hand, true, cards_n_values)
      puts "Sorry, #{users_name}, you bust."
      user_busts = true
    end


  end until user_stays == true or user_busts == true


  # Dealer's section
  if user_busts == false
    system 'clear'
    begin
      dealer_stays = false
      dealer_busts = false

      # While Dealer's hand is less than 17, Dealer continues to hit
      while sum_cards(dealers_hand, cards_n_values, "Dealer", false) < 17
        dealers_hand, deck_final = deal_a_card(dealers_hand, deck_final)
        display_both_hands(users_name, dealers_hand, users_hand, false, cards_n_values)
      end

      system 'clear'

        display_both_hands(users_name, dealers_hand, users_hand, false, cards_n_values)

      # Check whether Dealer has busted
      if player_busts?(dealers_hand, cards_n_values, "Dealer", false) == true
        puts "The Dealer busts, #{users_name} wins!"
        dealer_busts = true
      else
        # Comparison to see who wins
        dealers_final_hand_sum = sum_cards(dealers_hand, cards_n_values, "Dealer", false)
        users_final_hand_sum = sum_cards(users_hand, cards_n_values, users_name, false)

        if dealers_final_hand_sum > users_final_hand_sum
          puts "Dealer wins!"
        elsif dealers_final_hand_sum == users_final_hand_sum
          puts "It's a push. No winner."
        elsif dealers_final_hand_sum < users_final_hand_sum
          puts "You win, #{users_name}!"
        end
        # dealer_busts = true
        break
      end

    end until dealer_stays == true or dealer_busts == true or push == true
  end

  puts "Hit enter to play again or \"q\" to quit."

  if gets.chomp == "q"
    exit
  end

  system 'clear'

end until user_wants_to_continue == false
