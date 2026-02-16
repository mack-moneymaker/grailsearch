Rails.application.routes.draw do
  root "pages#home"

  get "search", to: "searches#show", as: :search
  get "pricing", to: "pages#pricing"

  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :saved_searches, only: [:index, :create, :destroy] do
    member do
      patch :toggle
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
