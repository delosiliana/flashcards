require 'rails_helper'

RSpec.describe 'Checking translation' do
  let!(:password) { 'password' }
  let(:user) { create(:user, password: password, password_confirmation: password) }
  let(:original_text) { 'Home' }
  let!(:card) { create :card, original_text: original_text, review_date: Date.today, user: user }

  before(:each) do
    visit login_url
    fill_in :user_email, with: user.email
    fill_in :user_password, with: password
    click_button 'Вход'

    visit root_path
  end

  context 'fill valide answer' do
    it 'should show success alert' do
      fill_in 'answer', with: original_text
      click_button 'Проверить введеный текст'
      expect(page).to have_text 'Верно'
    end
  end

  context 'fill invalide answer' do
    it 'should show success notice' do
      fill_in 'answer', with: 'invalide text'
      click_button 'Проверить введеный текст'
      expect(page).to have_text 'Не угадал, правильный ответ:'
    end
  end

  context 'upload picture for card' do
    before { visit edit_card_url(card) }

    it 'can upload picture' do
      attach_file 'card_picture', 'spec/files/image.jpg'
      click_button 'Update Card'
      expect(card.picture).not_to be_nil
    end
  end
end
