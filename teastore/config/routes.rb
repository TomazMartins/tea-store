Rails.application.routes.draw do
  resources :orders
  root to: 'home#index', as: :home

  resources :teas
end
