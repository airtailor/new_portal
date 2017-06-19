Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  # resources :stores do
  #   resources :orders do
  #     resources :items
  #   end
  # end

  # resources :stores do
  #   resources :orders
  #   # resources :tailor_orders, controller: 'orders'
  # end

  # get "/stores/:id", to: "stores#show"

  # patch "/orders/:id", to: "orders#update", as: :update_order
  # get "/orders/:id/edit", to: "orders#edit", as: :edit_order
  # get "/orders/new", to: "orders#new", as: :new_order
  # post "/orders", to: "orders#create", as: :create_order

  resources :stores do
    resources :orders
  end

  patch "/tailor_orders/:id", to: "orders#update", type: "tailor_order", as: :tailor_order
  # post "/tailor_orders", to: "orders#create", type: "TailorOrder"
  #resources :tailor_orders, :controller => "orders", :type => "TailorOrder"

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
