require 'rails_helper'

RSpec.describe 'Checking translation' do
  let!(:password) { 'password' }
  let(:user) { create(:user, password: password, password_confirmation: password) }
  let(:original_text) { 'Home' }
  let!(:deck) { create :deck, user: user }
  let!(:card) { create :card, original_text: original_text, review_date: Date.today, user: user, deck: deck }

  before(:each) do
    visit login_url
    fill_in :user_email, with: deck.user.email
    fill_in :user_password, with: password
    click_button 'Вход'

    visit root_path
  end

  context 'fill valide answer' do
    it 'should show success alert' do
      fill_in 'answer', with: original_text
      click_button 'Проверить введеный текст'
      expect(page).to have_text "Верно"
    end
  end

  context 'text which typo' do
      let(:translated_text) { 'hpme' }
      it "can see '' after tranlsate push" do
        fill_in 'answer', with: translated_text
        click_button 'Проверить введеный текст'
        expect(page).to have_text "Вы ввели ответ hpme но правильный ответ: Home"
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

    it 'can upload in sait' do
      fill_in 'card_picture_remote_url', with: 'https://www.royal-canin.ru/upload/iblock/a19/photo_9.jpg'
      click_button 'Update Card'
      expect(card.picture).not_to be_nil
    end
  end
end
