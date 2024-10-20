Rails.application.routes.draw do
  root 'home#index'
  get 'breeds', to: 'breeds#index'
  get 'about', to: 'home#about'
  get 'search', to: 'breeds#search'
end
