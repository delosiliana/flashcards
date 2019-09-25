require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  let!(:user) { create(:user, email: 'test@test.com') }
  let!(:user2) { create(:user, email: 'test2@test.com') }
  let!(:deck) { create(:deck, user: user) }
  let!(:deck2) { create(:deck, user: user2) }
  let!(:card) { create(:card, user: user, deck: deck) }
  let!(:card2) { create(:card, user: user2, deck: deck2) }

  before(:each) do
    login_user(user, login_url)
    get :index
  end

  describe 'GET #index' do
    it 'renders index view' do
      expect(response).to render_template :index
    end

    context 'when user visit all cards page' do
      it 'watching his cards' do
        expect(assigns(:cards)).to include(card)
      end

      it 'does not see user2 cards' do
        expect(assigns(:cards)).not_to include(card2)
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: card } }
    it 'assigns the requested card to @card' do
      expect(assigns(:card)).to eq card
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new Card to @card' do
      expect(assigns(:card)).to be_a_new(Card)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'DELETE #destroy' do
    context 'author  tries to delete card' do
      it 'author delete card' do
        expect { delete :destroy, params: { id: card } }.to change(Card, :count).by(-1)
      end

      it 'redirect to cards_path' do
        delete :destroy, params: { id: card }
        expect(response).to redirect_to cards_path
      end
    end

    context 'no author  tries to delete card' do
      it 'can not delete card' do
        expect { delete :destroy, params: { id: card2 } }.to_not change(Card, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assings the requested card to @card' do
        patch :update, params: { id: card, card: attributes_for(:card) }

        expect(assigns(:card)).to eq card
      end

      it 'changes card attributes' do
        patch :update, params: { id: card, card: { original_text: 'new title', translated_text: 'new body'} }
        card.reload

        expect(card.original_text).to eq card.original_text
        expect(card.translated_text).to eq card.translated_text
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: card, card: { original_text: 'new title', translated_text: nil } } }

      it 'does not change question attributes' do
        card.reload
        expect(card.original_text).to eq card.original_text
        expect(card.translated_text).to eq card.translated_text
      end
    end

    context 'no author  tries to update card' do
      it 'can not update card' do
        expect { patch :update, params: { id: card2 } }.to_not change(Card, :count)
      end
    end
  end
end
