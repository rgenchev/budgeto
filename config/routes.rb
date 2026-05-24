Rails.application.routes.draw do
  resource :session

  namespace :my do
    resource :account, only: [:show, :edit, :update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get 'dashboard', to: 'dashboard#index', as: :dashboard

  resources :expenses, only: [:index, :create, :edit, :update, :destroy]
  resources :incomes, only: [:index, :create, :edit, :update, :destroy]
  resources :taxes, only: [:index, :create, :edit, :update, :destroy]
  resources :categories

  root "dashboard#index"
end
