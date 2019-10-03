require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:user) { create :user }
  let(:deck) { create(:deck, user: user)}
  it "becomes current if Make current is selected" do
    deck.set_current
    expect(deck.current).to eq true
  end

  let(:deck2) { create(:deck, user: user, title: 'House') }
  it "becomes current if Make current is selected" do
    deck.set_current
    expect(deck2.current).to eq false
  end
end
