Rails.application.routes.draw do
  root 'home#index'
  
  get 'about', to: 'home#about'
  get 'search', to: 'breeds#search'

  resources :dogs, only: [:index] # Route for the dogs index page
  resources :breeds do
    resources :sub_breeds, only: [:index, :show] # Nested routes for sub_breeds
  end
end
