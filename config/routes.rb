Rails.application.routes.draw do
  root to: "home#index"

  # These routes are added by mount_devise_token_auth.
  # - POST '/' => email registration. needs email, password, password_confirmation and confirmation_success_url (unless we've set a default confirm_success_url)
  # - DELETE '/' => account deletion, destroys users. needs uid, access-token and client.
  # - PUT '/' => update account, and needs password + password_confirmation + other things if we want to add those using devise_parameter_sanitizer (no idea what that is)
  #   - we can set config.check_current_password_before_update to :attributes to check PW before any update, or :password for only user-password updates.
  # - POST '/sign_in' => email auth. Returns User, access-token and client.
  # - DELETE '/sign_out' => end the current user's session, invalidating auth token. needs uid, client, and access-token.
  # - GET '/:provider' => destination for client authentication. We don't need that.
  # - GET/POST '/:provider/callback' => destination for the oauth2 provider's callback uri. not something we need.
  # - GET '/validate_token' => validates tokens, needs uid, client and access-token (should match User table)
  # - POST '/password' => password reset, needs email + redirect_url.
  # - PUT '/password' => change a user's passwords. needs password and password_confirmation. Also checks current_password if config.check_current_password_before_update is not false.
  # - GET '/password/edit' => verify user by password reset token (destination URL for reset confirmation). it has to have reset_password_token and redirect_url params.


  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks],
    controllers: {
      token_validations: 'overrides/token_validations',
      sessions: 'overrides/sessions',
      registrations: 'overrides/registrations'
    }

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

    get "/reports/current_report", to: "reports#current_report"

  end
end
