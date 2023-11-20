Rails.application.routes.draw do
  devise_for :guests
  devise_for :innkeepers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :inns, except: :destroy do
    resources :rooms, shallow: true, only: [:show]
  end

  resources :rooms do
    member do
      get "verification" => "rooms#verification", as: :availability_verification
      post "verify" => "rooms#verify", as: :verify_availability
    end
  end

  resources :bookings, only: [:new, :create, :index, :show] do
    member do
      post "cancel" => "bookings#cancel"
    end
  end

  resource :own_inn, except: [:destroy], controller: :own_inn do
    resources :rooms, controller: :own_inn_rooms do
      resources :custom_prices, controller: :own_inn_room_custom_prices
    end

    resources :bookings, only: [:index], controller: :own_inn_bookings
  end

  get "search/by-city/:city" => "search#search_by_city", as: :search_by_city
  post "search" => "search#search", as: :search
  post "search/advanced" => "search#advanced_search", as: :advanced_search

  # Defines the root path route ("/")
  root "inns#index"
end
