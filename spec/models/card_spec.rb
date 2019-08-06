require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:card) { create(:card) }

  context 'create card' do
    it 'saves successfully' do
      card.save!
      expect(card).to eq(card)
    end

    it 'has a valid factory' do
      expect(card).to be_valid
    end

    it "Invalid original_text equals to translated_text" do
      card = Card.create(original_text: 'Дом', translated_text: 'дом')
      expect(card.errors.values).to include(["Должна быть разница между оригинальным и переведенным текстом"])
    end

    it "returns a random card by last date" do
      expect(Card.sort_random.to_sql).to include('RANDOM()')
    end
  end

  describe '#set_review_date' do
    context 'after create card' do
      it "card's review date will be three days older then today" do
        expect(card.review_date.to_date - 3).to eql(Time.now.to_date)
      end

      it "extract a review_date" do
        expect(card.review_date).to eq(Date.today + 3.days)
      end
    end
  end

  describe '#check_original_text_answer(answer)' do
    context 'given wrong translate' do
      it 'return false' do
        expect(card.check_original_text_answer('книга')).to be false
      end
    end
  end

  let(:card) { create(:card, original_text: 'дом') }
  context 'given translate in capital letters' do
    it 'return true' do
      expect(card.check_original_text_answer('ДоМ')).to be true
    end
  end

  context 'given translate in normal letters' do
    it 'return true' do
      expect(card.check_original_text_answer('дом')).to be true
    end
  end
end
