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

  namespace :guest do
    resources :bookings, only: [:new, :create, :index, :show] do
      member do
        post "cancel" => "bookings#cancel"
      end

      resources :reviews, only: [:new, :create]
    end
  end

  namespace :host do
    resource :inn, except: :destroy, controller: :inn do
      resources :rooms do
        resources :custom_prices
      end

      resources :bookings, only: [:index, :show] do
        member do
          post "check_in" => "bookings#check_in"
          get "check_out" => "bookings#checking_out"
          post "check_out" => "bookings#check_out"
          post "cancel" => "bookings#cancel"
        end
      end
    end
  end

  namespace :search do
    get "/simple" => "search#search"
    get "/advanced" => "search#advanced_search"
    get "/by_city/:city" => "search#search_by_city", as: :by_city
  end

  # Defines the root path route ("/")
  root "inns#index"
end
