Rails.application.routes.draw do
  resources :cards, except: :show

  root 'flashcards#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
