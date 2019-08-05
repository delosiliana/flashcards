Rails.application.routes.draw do
  resources :cards, except: :show

  resources :cards do
    member do
      post 'check_original_text_card'
    end
  end

  root 'flashcards#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
