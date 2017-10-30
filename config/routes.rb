Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  #devise_for :users

  root to: "home#index"

  # namespace :admin  do
  #   get "/users", to: "users#index", as: :users
  #   get "/users/new", to: "users#new", as: :new_user
  #   get "/users/:id", to: "users#show", as: :user
  #   get "/users/:id/edit", to: "users#edit", as: :edit_user
  #   post "/users", to: "users#create"
  #   patch "/users/:id", to: "users#update"
  #   delete "/users/:id", to: "users#destroy"
  # end

  namespace :api, defaults: {format: 'json'} do
    get '/stores/:id/orders_and_messages_count', to: "stores#orders_and_messages_count"

    get "/orders/search/:query", to: "orders#search"
    get "/orders/archived", to: "orders#archived"
    get "/new_orders", to: "orders#new_orders"

    resources :stores do
      resources :orders
      resources :conversations do
        resources :messages
      end
    end

    resources :orders

    resources :shipments
    resources :companies
    post "/customers/find_or_create", to: "customers#find_or_create"

    get "/customers/:customer_id/measurements/last", to: "measurements#show"
    post "/customers/:customer_id/measurements", to: "measurements#create"
    resources :customers
    # resources :addresses

    resources :item_types
    post "/shopify_order", to: "shopify#receive"
    resources :sessions, only: [:create, :destroy]
    resources :tailors

    put "/users/:id/update_password", to: "users#update_password"
  end
end
