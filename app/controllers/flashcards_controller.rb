class FlashcardsController < ApplicationController
  def index
    #@card = Card.dated.sort_random.last
    @card = if current_user && current_user.decks.find_current_deck.nil?
      Card.dated.sort_random.last
    elsif current_user && !current_user.decks.find_current_deck.nil?
      current_user.decks.find_current_deck.cards.dated.sort_random.last
    else
      nil
    end
  end
end
