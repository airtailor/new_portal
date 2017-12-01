Rails.application.routes.draw do
  root to: "home#index"

  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  namespace :api, defaults: {format: 'json'} do
    get '/stores/:id/orders_and_messages_count', to: "stores#orders_and_messages_count"
    put "/stores/:id/orders/alert_customers", to: "orders#alert_customers"

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

    post "/customers/create_or_validate_customer", to: "customers#create_or_validate_customer"
    get "/customers/:customer_id/measurements/last", to: "measurements#show"
    post "/customers/:customer_id/measurements", to: "measurements#create"
    resources :customers
    # resources :addresses

    resources :item_types
    post "/shopify_order", to: "shopify#receive"
    resources :sessions, only: [:create, :destroy]
    resources :tailors

    put "/users/:id/update_password", to: "users#update_password"
    get "/reports/current_report", to: "reports#current_report"
    
  end
end
