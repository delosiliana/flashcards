Rails.application.routes.draw do
  root 'flashcards#index'
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
  get 'signup' => 'users#new', :as => :signup

  resources :cards, except: :show
  resources :users
  resources :user_sessions

  resources :cards do
    member do
      post 'check_original_text_card'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
