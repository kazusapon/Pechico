Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html]
  root to: 'sessions#new'

  resources :dashboard, only: [:index]
  
  resources :common_inquiries, except: :show do
    collection do
      get 'search', to: 'common_inquiries#search'
    end
  end

  resources :sessions, only: [:new, :create] do
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

  resources :users, except: :show do
    member do
      get 'resurrect'
    end
  end

  resources :systems, except: :show do
    member do
      get 'resurrect'
    end
  end

  resources :inquiry_classifications, except: :show do
    member do
      get 'resurrect'
    end
  end

  resources :inquirier_kinds, except: :show do
    member do
      get 'resurrect'
    end
  end
end
