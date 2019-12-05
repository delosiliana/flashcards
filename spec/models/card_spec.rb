require 'rails_helper'

RSpec.describe Card, type: :model do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user: user) }
  let(:card) { create(:card, deck: deck, user: user) }
  let(:invalid_card) { build(:card, original_text: 'Home', translated_text: 'home') }

  context 'create card' do
    it 'saves successfully' do
      card.save!
      expect(card).to eq(card)
    end

    it 'has a valid factory' do
      expect(card).to be_valid
    end

    it "returns a random card by last date" do
      expect(Card.sort_random.to_sql).to include('RANDOM()')
    end

    it "Invalid original_text equals to translated_text" do
      expect(invalid_card.check_text).to include("Должна быть разница между оригинальным и переведенным текстом")
    end
  end

  describe '#set_review_date' do
    context 'after create card' do
      it "extract a review_date" do
        expect(card.review_date).to eql(Time.now.to_date)
      end
    end
  end

  describe '#check_original_text_answer(answer)' do
    let(:card) { create(:card, original_text: 'дом', user: user, deck: deck) }
    context 'given wrong translate' do
      it 'return false' do
        expect(card.check_original_text_answer('книга')).to be false
      end
    end

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

    context "update review date" do
      it 'correct answer' do
        card.update(try_count: 0, mistake_count: 0, review_date: DateTime.current)
        expect(card.check_original_text_answer('дом')).to be true
        card.rise_try_count
        expect(card.try_count).to eq(1)
        expect(card.review_date).to be_within(1.minute).of(DateTime.current + 12.hours)
      end
    end

    context "check count try and mistake" do
      it "given count_try" do
        card.update(try_count: 0, mistake_count: 0)
        card.rise_try_count
        expect(card.try_count).to eq(1)
        expect(card.mistake_count).to eq(0)
        card.update(try_count: 1, mistake_count: 0)
        card.rise_try_count
        expect(card.try_count).to eq(2)
        expect(card.mistake_count).to eq(0)
      end

      it "given mistake count" do
        card.update(try_count: 0, mistake_count: 0)
        expect(card.check_original_text_answer('Домина')).to be false
        card.process_mistake
        expect(card.try_count).to eq(0)
        expect(card.mistake_count).to eq(1)
      end
    end
  end
end
