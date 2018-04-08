require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewAirtailorPortal
  class Application < Rails::Application
    config.autoload_paths << File.join(Rails.root, 'app', 'classes')
    config.autoload_paths << File.join(Rails.root, 'app', 'classes', 'api')

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/v1/orders',
          :headers => :any,
          :expose  => ['X_Api_Key'],
          :methods => [:post]
      end
    end
  end
end
