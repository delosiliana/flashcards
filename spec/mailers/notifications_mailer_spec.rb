require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe "pending_cards" do
    #let(:mail) { NotificationsMailer.pending_cards }

    #it "renders the headers" do
    #  expect(mail.subject).to eq("Pending cards")
    #  expect(mail.to).to eq(["to@example.org"])
    #  expect(mail.from).to eq(["from@example.com"])
    #end

    #it "renders the body" do
    #  expect(mail.body.encoded).to match("Hi")
    #end

    let!(:user) { create :user }
    let(:deck) { create(:deck, user: user) }
    let!(:card) { create(:card, deck: deck, user: user) }
    let!(:mail) { NotificationsMailer.pending_cards(user) }

    it 'renders the user email' do
      expect(mail.to).to eq [user.email]
    end

    it 'render subject' do
      expect(mail.subject).to have_content 'Карточки, которые ожидают пересмотра'
    end

    it 'renders sender email' do
      expect(mail.from).to eq ['flashcard@evening-springs-73503.herokuapp.com']
    end
  end
end
