Rails.application.routes.draw do
  root to: 'home#index', as: :home

  resources :teas

  resources :clients do
    resources :orders, name_prefix: 'client_'
  end
end
