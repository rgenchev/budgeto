Rails.application.routes.draw do
  resource :session

  get "up" => "rails/health#show", as: :rails_health_check
  get 'dashboard', to: 'dashboard#index', as: :dashboard

  resources :expenses, only: [:index, :create]
  resources :incomes, only: [:index, :create]
  resources :categories

  root "dashboard#index"
end
