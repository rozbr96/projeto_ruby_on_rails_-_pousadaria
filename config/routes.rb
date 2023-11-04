Rails.application.routes.draw do
  devise_for :innkeepers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :inns, except: :destroy
  resource :own_inn, except: [:destroy], controller: :own_inn do
    resources :rooms, controller: :own_inn_rooms
  end

  # Defines the root path route ("/")
  root "inns#index"
end
