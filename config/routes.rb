Rails.application.routes.draw do
  resources :cards, except: :show
  post 'card_check_original_text_card', to: 'cards#check_original_text_card'

  root 'flashcards#index'
  get 'flashcards/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
