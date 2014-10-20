# blackjack.rb

=begin
Rules & Requirements:

Blackjack is a card game where you calculate the sum of the values of your cards and try to hit 21, aka "blackjack". Both the player and dealer are dealt two cards to start the game. All face cards are worth whatever numerical value they show. Suit cards are worth 10. Aces can be worth either 11 or 1. Example: if you have a Jack and an Ace, then you have hit "blackjack", as it adds up to 21.

After being dealt the initial 2 cards, the player goes first and can choose to either "hit" or "stay". Hitting means deal another card. If the player's cards sum up to be greater than 21, the player has "busted" and lost. If the sum is 21, then the player wins. If the sum is less than 21, then the player can choose to "hit" or "stay" again. If the player "hits", then repeat above, but if the player stays, then the player's total value is saved, and the turn moves to the dealer.

By rule, the dealer must hit until she has at least 17. If the dealer busts, then the player wins. If the dealer, hits 21, then the dealer wins. If, however, the dealer stays, then we compare the sums of the two hands between the player and dealer; higher value wins.

Hints:
1. Think of the data structure required to keep track of cards in a deck.
2. You'll need to look up and use a "while" loop, since there could be an indeterminate number of "hits" by both the player and dealer. "while" loops are used when we don't have a finite number of iterations.
3. Code something. Get started, even if it's just capturing the player's name. Give it an honest attempt before looking at solutions.
4. Use methods to extract the piece of functionality that calculates the total, since we need it throughout the program.

Bonus:
1. Save the player's name, and use it throughout the app.
x 2. Ask the player if he wants to play again, rather than just exiting.
x 3. Save not just the card value, but also the suit.
x 4. Use multiple decks to prevent against card counting players.
5 - Blackjack wins immediately ()
############################################################################

  Logic:
    1 - Loop for continuing game until user wants to quit
    2 - Setup deck of cards
      a - Keep track of which which cards have been removed from the deck as they are dealt
      b - Allow variable amount of decks to use in the game -- are you able to do this without using classes?
    3 - Two sections: the User's and the dealer.
=end

## START - Methods #############################################################
require 'pry'

def player_busts?(hand, cards_n_values, player, initial_deal_bool)
  if sum_cards(hand, cards_n_values, player, initial_deal_bool) > 21
    return true
  else
    return false
  end
end

# Determine which player is the winner -- returns users_name, "push", or "Dealer"
def who_is_winner?(users_name, users_hand, dealers_hand, cards_n_values, initial_deal_bool)
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
  # Ace card is both 1 and 11
  sum = 0
  num_of_aces = 0

  if player == "Dealer" and initial_deal_bool == true
    # Only sum the Dealer's showing card
    card = hand[0]
    card = card.split("_")[1]

    if card == 11
      num_of_aces += 1
    end

    sum += cards_n_values[card]

  else
    # User's hand sum calculation
    hand.each_with_index do |card, i|
      card = card.split("_")[1]           # card is string with suit and number. Remove suit and only use the number.
      if cards_n_values[card] == 11
        num_of_aces += 1
      end

      #binding.pry
      sum += cards_n_values[card]
    end
  end

  while sum > 21 and num_of_aces > 0
    sum = sum - 11 + 1
    num_of_aces -= 1
  end

  sum
end

# Method to deal card to player,
# returns new hand and deck_final
def deal_a_card(players_hand, deck_final)
    players_hand << deck_final.pop
    return players_hand, deck_final
end

def display_players_hand(player, players_hand, initial_deal_bool, cards_n_values)
  puts "#{player}'s cards: \n"

  # If player is dealer and this is the initial deal, do NOT show the second card.
  if initial_deal_bool == true and player == "Dealer"
    players_hand.each_with_index do |card, i|
      if i == players_hand.length - 1
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
############################################################## END - Methods ###


## START - Pseudo Code ######################################################
=begin
PSEUDO_CODE

welcome text

loop play game

  x shuffle decks
  x deal two cards to each player
  x dealer shows one card faceup, other is facedown

  loop # User's section
    x Ask User to hit or stay
    Display new card and total

    if card total is <= 21
      continue with loop
    else
      User has bust, end game
      show end text

    end
  end until when User stays or busts
  loop # dealer's section
    show both cards to User

    while dealer's cards total < 17, keep hitting
      if dealer's cards total >= 17 and < 21
        stay
        break
      elsif dealer's cards total > 21
        busts, User wins
        break
      end
    end

    determine_winner(Users' cards, dealer's cards)

  end
  ask whether User wants to play again

end until User wants to quit: exit command
=end
########################################################## END - Pseudo Code ###

## START - Program ###########################################################
user_wants_to_continue = true

suits = %w(Diamond Spade Club Heart)

values = [11,2,3,4,5,6,7,8,9,10,10,10,10]
keys = %w( Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)

cards_n_values = {}

keys.each_with_index do |k,i|
  cards_n_values[k] = values[i]
end

deck_base = []

# Create deck template
suits.each_with_index do |suit, i|
  cards_n_values.each do |k,v|
    deck_base << suit + "_"+ k
  end
end

num_of_decks_to_use = 2
deck_final = []

# Generate final deck based on number of full desks to use in game
(1..num_of_decks_to_use).each do |x|
    deck_base.each_with_index do |e,i|
        deck_final << e
    end
end

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
    # Display DEALER's cards
    display_players_hand("Dealer", dealers_hand, true, cards_n_values)
    puts
    display_players_hand(users_name, users_hand, false, cards_n_values)
    puts

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

      while sum_cards(dealers_hand, cards_n_values, "Dealer", false) < 17
        dealers_hand, deck_final = deal_a_card(dealers_hand, deck_final)
        display_players_hand("Dealer", dealers_hand, false, cards_n_values)
        display_players_hand(users_name, users_hand, false, cards_n_values)
      end

      system 'clear'

      display_players_hand("Dealer", dealers_hand, false, cards_n_values)
      display_players_hand(users_name, users_hand, false, cards_n_values)

      if player_busts?(dealers_hand, cards_n_values, "Dealer", false) == true
        puts "The Dealer busts, #{users_name} wins!"
        dealer_busts = true
      else
        # Comparison to see who wins
        dealers_final_hand_sum = sum_cards(dealers_hand, cards_n_values, "Dealer", false)
        users_final_hand_sum = sum_cards(users_hand, cards_n_values, users_name, false)

        if dealers_final_hand_sum > users_final_hand_sum
          puts " Dealer wins!"
        elsif dealers_final_hand_sum == users_final_hand_sum
          puts "It's a push. No winner."
        elsif dealers_final_hand_sum < users_final_hand_sum
          puts "You win, #{users_name}!"
        end
        dealer_busts = true
      end

    end until dealer_stays == true or dealer_busts == true or push == true
  end

  puts "Hit enter to play again or \"q\" to quit."

  if gets.chomp == "q"
    exit
  end

  system 'clear'

end until user_wants_to_continue == false





















############################################################ END - Program #####
