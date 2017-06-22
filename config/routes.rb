Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  resources :stores do
    resources :orders
  end

  patch "/tailor_orders/:id", to: "orders#update", type: "tailor_order", as: :tailor_order
  patch "/welcome_kits/:id", to: "orders#update", type: "welcome_kit", as: :welcome_kit

  resources :shipments

  namespace :admin  do
    get "/users", to: "users#index", as: :users
    get "/users/new", to: "users#new", as: :new_user
    get "/users/:id", to: "users#show", as: :user
    get "/users/:id/edit", to: "users#edit", as: :edit_user
    post "/users", to: "users#create"
    patch "/users/:id", to: "users#update"
    delete "/users/:id", to: "users#destroy"
  end

  namespace :api do
    post "/shopify_order", to: "shopify#receive"
  end
end
