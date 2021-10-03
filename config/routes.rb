Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html]
  root to: 'sessions#new'

  resources :sessions, only: [:new, :create]
  resources :dashboard, only: [:index]
  resources :users, except: :show
  resources :systems, except: :show
  resources :inquiry_classifications, except: :show
  resources :inquirier_kinds, except: :show
  resources :common_inquiries, except: :show

  resource :session do
    collection do
      get 'logout', to: 'sessions#destroy'
    end
  end

  resources :inquiries do
    collection do
      get 'related_inquiries', to: 'inquiries#related_inquiries'
    end

    member do
      get 'resurrect', to: 'inquiries#resurrect'
    end
  end

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

  resource :inquiry_classifications do
    member do
      get 'resurrect'
    end
  end

  resource :inquirier_kinds do
    member do
      get 'resurrect'
    end
  end
end
