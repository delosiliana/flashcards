require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:user) { create :user }
  let(:deck) { create(:deck, user: user)}

  context 'create deck' do
    it 'saves successfully' do
      deck.save!
      expect(deck).to eq(deck)
    end

    it 'has a valid factory' do
      expect(deck).to be_valid
    end
  end
end
