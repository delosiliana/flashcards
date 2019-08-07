require 'rails_helper'

RSpec.describe 'Checking translation' do
  let(:original_text) { 'Home' }
  let!(:card) { create :card, original_text: original_text, review_date: Date.today }

  before { visit root_path }

  context 'fill valide answer' do
    it 'should show success alert' do
      fill_in 'answer', with: original_text
      click_button 'Проверить введеный текст'
      expect(page).to have_text 'Верно'
    end
  end

  context 'fill invalide answer' do
    it 'should show success notice' do
      fill_in 'answer', with: 'test'
      click_button 'Проверить введеный текст'
      expect(page).to have_text 'Не угадал, правильный ответ:'
    end
  end
end
