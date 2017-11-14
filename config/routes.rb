Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  root to: "home#index"

  resources :stores do
    resources :orders
  end

  patch "/tailor_orders/:id", to: "orders#update", type: "tailor_order", as: :tailor_order
  patch "/welcome_kits/:id", to: "orders#update", type: "welcome_kit", as: :welcome_kit


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

    resources :item_types
    post "/shopify_order", to: "shopify#receive"
    resources :sessions, only: [:create, :destroy]
    resources :tailors

    resources :charges
    post "/update_payment_method", to: "payments#update_payment_method"

    put "/users/:id/update_password", to: "users#update_password"
  end
end
