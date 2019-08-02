class FlashcardsController < ApplicationController
  def index
    @card = Card.dated.sort_random.last
  end
end
