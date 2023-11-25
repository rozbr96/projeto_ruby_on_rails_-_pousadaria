Rails.application.routes.draw do
  devise_for :guests
  devise_for :innkeepers

  resources :inns, except: :destroy do
    resources :rooms, shallow: true, only: :show

    member do
      get "reviews" => "inns#reviews"
    end
  end

  resources :rooms, only: [:show] do
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

      resources :reviews, shallow: true, only: [:new, :create, :show]
    end

    get "reviews" => "reviews#index"
  end

  namespace :host do
    resource :inn, except: :destroy, controller: :inn do
      resources :rooms, except: :destroy do
        resources :custom_prices, except: :destroy
      end

      resources :bookings, only: [:index, :show] do
        member do
          post "check_in" => "bookings#check_in"
          get "check_out" => "bookings#checking_out"
          post "check_out" => "bookings#check_out"
          post "cancel" => "bookings#cancel"
        end
      end

      resources :reviews, only: [:index, :update] do
        get "replying" => "reviews#replying"
        post "reply" => "reviews#reply"
      end
    end
  end

  namespace :search do
    get "/simple" => "search#search"
    get "/advanced" => "search#advanced_search"
    get "/by_city/:city" => "search#search_by_city", as: :by_city
  end

  root "inns#index"
end
