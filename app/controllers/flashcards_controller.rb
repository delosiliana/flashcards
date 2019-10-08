class FlashcardsController < ApplicationController
  def index
    @card = if current_user && current_user.current_deck.nil?
      Card.dated.sort_random.last
    elsif current_user.current_deck.present?
      current_user.current_deck.cards.dated.sort_random.last
    else
      nil
    end
  end
end
