Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  resources :stores do
    resources :orders do
      resources :items
    end
  end

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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
