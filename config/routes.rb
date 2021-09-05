Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html]
  root to: 'sessions#new'

  resources :sessions, only: [:new, :create, :destroy]
  resources :dashboard, only: [:index]
  resources :users, except: :show
  resources :systems, except: :show

  resource :users do
    member do
      get 'resurrect'
    end
  end

  resource :systems do
    member do
      get 'resurrect'
    end
  end
end
