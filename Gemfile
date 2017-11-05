source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.3'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

#gem 'bcrypt', '~> 3.1.7'
#
gem 'devise_token_auth'
gem 'omniauth'
gem 'cancancan'
gem 'rolify'
gem 'rack-cors'

gem 'send_sonar'
#gem 'shippo', '~> 2.0.4'
gem 'shippo', '~> 3.0.0'
gem 'postmates'
gem 'airbrake'
gem 'pdfkit'
gem 'render_anywhere', :require => false
gem 'wkhtmltopdf-binary'
gem 'delighted'
gem 'chartkick'
gem 'groupdate'
gem 'httparty'
gem 'hashie'
gem 'textacular', '~> 5.0'

# Background job processing + asymc
gem 'sidekiq'

# Address parsing.
# IT IS OLD AND LIABLE TO EXPLODE.
gem 'street_address', '~> 2.0', git: 'git@github.com:nialbima/street-address.git'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'better_errors'
  gem 'pry'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
