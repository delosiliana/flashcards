require 'rails_helper'

RSpec.describe 'Decks' do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }

  before(:each) do
    visit login_url
    fill_in :user_email, with: user.email
    fill_in :user_password, with: password
    click_button 'Вход'

    visit root_path
  end

  describe '#new' do
    it 'will create a new deck' do
      visit new_deck_path
      fill_in 'Название колоды', with: 'Первая'
      click_button 'Create Deck'
      expect(page).to have_content 'Колода создана'
    end
  end
end
